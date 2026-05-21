using System.Collections.ObjectModel;
using System.IO;
using System.Text.Json;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Threading;
using Microsoft.Win32;
using RecloserOptimisation.App.Models;
using WinForms = System.Windows.Forms;

namespace RecloserOptimisation.App;

public partial class MainWindow : Window
{
    private readonly ObservableCollection<StagedImport> _imports = new();
    private readonly ObservableCollection<ImportAdapter> _adapters = new();
    private readonly ObservableCollection<ReportRow> _reports = new();
    private readonly Dictionary<string, FrameworkElement> _pages;
    private readonly Button[] _navButtons;
    private readonly JsonSerializerOptions _jsonOptions = new() { WriteIndented = true };

    private bool _isDragging;
    private Point _lastDragPoint;
    private double _centerLat = -38.335;
    private double _centerLng = 175.165;
    private int _zoom = 10;
    private string _activeLayer = "Street";

    public MainWindow()
    {
        InitializeComponent();

        _pages = new Dictionary<string, FrameworkElement>
        {
            ["Dashboard"] = DashboardPage,
            ["Ingestion"] = IngestionPage,
            ["Processing"] = ProcessingPage,
            ["Model"] = ModelPage,
            ["Map"] = MapPage,
            ["Explorer"] = ExplorerPage,
            ["Validation"] = ValidationPage,
            ["Analysis"] = AnalysisPage,
            ["Outages"] = OutagesPage,
            ["Reports"] = ReportsPage,
            ["Settings"] = SettingsPage,
        };

        _navButtons = new[]
        {
            NavDashboard,
            NavIngestion,
            NavProcessing,
            NavModel,
            NavMap,
            NavExplorer,
            NavValidation,
            NavAnalysis,
            NavOutages,
            NavReports,
            NavSettings,
        };

        ImportsGrid.ItemsSource = _imports;
        DashboardImportsGrid.ItemsSource = _imports;
        AdapterSummaryGrid.ItemsSource = _adapters;
        ReportsGrid.ItemsSource = _reports;

        BindEvents();
        LoadAdapters();
        LoadReports();
        ShowPage("Dashboard");
    }

    private void BindEvents()
    {
        foreach (var button in _navButtons)
        {
            button.Click += (_, _) => ShowPage((string)button.Tag);
        }

        TopImportButton.Click += (_, _) =>
        {
            ShowPage("Ingestion");
            ChooseImportFiles();
        };
        ChooseFilesButton.Click += (_, _) => ChooseImportFiles();
        ChooseFolderButton.Click += (_, _) => ChooseImportFolder();
        ClearImportsButton.Click += (_, _) =>
        {
            _imports.Clear();
            SetStatus("Staged imports cleared");
        };
        ExportManifestButton.Click += (_, _) => ExportManifest();
        ExportImportManifestButton.Click += (_, _) => ExportManifest();
        ExportTemplateButton.Click += (_, _) => ExportTemplate();
        ExportGeoJsonButton.Click += (_, _) => ExportGeoJson();
        CenterMapButton.Click += (_, _) => CenterMap();
        OverlayToggle.Checked += (_, _) => MapEmptyBadge.Visibility = Visibility.Visible;
        OverlayToggle.Unchecked += (_, _) => MapEmptyBadge.Visibility = Visibility.Collapsed;
        MapLayerCombo.SelectionChanged += (_, _) =>
        {
            if (MapLayerCombo.SelectedItem is ComboBoxItem item)
            {
                _activeLayer = item.Content.ToString() ?? "Street";
                RenderMap();
                SetStatus($"{_activeLayer} basemap selected");
            }
        };

        MapHost.SizeChanged += (_, _) => RenderMap();
        MapHost.MouseWheel += MapHostOnMouseWheel;
        MapHost.MouseLeftButtonDown += MapHostOnMouseLeftButtonDown;
        MapHost.MouseLeftButtonUp += MapHostOnMouseLeftButtonUp;
        MapHost.MouseLeave += (_, _) => StopMapDrag();
        MapHost.MouseMove += MapHostOnMouseMove;
    }

    private void LoadAdapters()
    {
        _adapters.Clear();
        var path = Path.Combine(AppContext.BaseDirectory, "Config", "import-adapters.json");

        if (!File.Exists(path))
        {
            path = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "config", "import-adapters.json"));
        }

        if (File.Exists(path))
        {
            var json = File.ReadAllText(path);
            var adapters = JsonSerializer.Deserialize<List<ImportAdapter>>(json) ?? new List<ImportAdapter>();
            foreach (var adapter in adapters)
            {
                _adapters.Add(adapter);
            }
        }

        if (_adapters.Count == 0)
        {
            _adapters.Add(new ImportAdapter
            {
                Category = "GIS",
                Platform = "Esri ArcGIS",
                Formats = "SHP, FileGDB, GeoJSON",
                Status = "Planned",
                Purpose = "Spatial network and asset layers",
            });
        }
    }

    private void LoadReports()
    {
        _reports.Clear();
        _reports.Add(new ReportRow { Report = "Network model summary", Category = "Model", Status = "Unavailable" });
        _reports.Add(new ReportRow { Report = "SAIDI / SAIFI comparison", Category = "Analysis", Status = "Unavailable" });
        _reports.Add(new ReportRow { Report = "Validation issue register", Category = "Validation", Status = "Unavailable" });
    }

    private void ShowPage(string name)
    {
        foreach (var page in _pages)
        {
            page.Value.Visibility = page.Key == name ? Visibility.Visible : Visibility.Collapsed;
        }

        foreach (var button in _navButtons)
        {
            var active = (string)button.Tag == name;
            button.Background = BrushFrom(active ? "#1D5ECF" : "Transparent");
            button.Foreground = BrushFrom(active ? "#FFFFFF" : "#DBE9FB");
        }

        var titles = new Dictionary<string, (string Subtitle, string Title)>
        {
            ["Dashboard"] = ("Prototype", "Dashboard"),
            ["Ingestion"] = ("Source staging", "Ingestion"),
            ["Processing"] = ("Pipeline", "Processing"),
            ["Model"] = ("Internal network model", "Model Building"),
            ["Map"] = ("Geospatial workspace", "Topology Map"),
            ["Explorer"] = ("Asset search", "Model Explorer"),
            ["Validation"] = ("Quality gates", "Validation"),
            ["Analysis"] = ("Reliability studies", "Analysis"),
            ["Outages"] = ("Historical performance", "Outages"),
            ["Reports"] = ("Outputs", "Reports"),
            ["Settings"] = ("Workspace", "Settings"),
        };

        ViewSubtitle.Text = titles[name].Subtitle;
        ViewTitle.Text = titles[name].Title;
        SetStatus($"Viewing {titles[name].Title}");

        if (name == "Map")
        {
            Dispatcher.BeginInvoke(new Action(RenderMap), DispatcherPriority.Loaded);
        }
    }

    private static Brush BrushFrom(string color)
    {
        return (Brush)new BrushConverter().ConvertFromString(color)!;
    }

    private void ChooseImportFiles()
    {
        var dialog = new OpenFileDialog
        {
            Multiselect = true,
            Title = "Import source files",
            Filter = "Supported source files|*.csv;*.xlsx;*.xls;*.json;*.geojson;*.shp;*.dbf;*.prj;*.shx;*.zip;*.gpkg;*.kml;*.kmz;*.tab;*.mif;*.mid;*.dxf;*.dwg;*.dxl;*.dss;*.glm;*.xml;*.rdf;*.raw;*.olr;*.cfg;*.dat;*.txt;*.m;*.mat;*.mdb;*.accdb|All files|*.*",
        };

        if (dialog.ShowDialog(this) != true)
        {
            return;
        }

        foreach (var fileName in dialog.FileNames)
        {
            AddImportPath(fileName);
        }

        SetStatus($"{dialog.FileNames.Length} import file(s) staged");
    }

    private void ChooseImportFolder()
    {
        using var dialog = new WinForms.FolderBrowserDialog
        {
            Description = "Select a File Geodatabase, GIS export folder, model folder or platform project folder",
            UseDescriptionForTitle = true,
        };

        if (dialog.ShowDialog() == WinForms.DialogResult.OK)
        {
            AddImportPath(dialog.SelectedPath);
            SetStatus("Import folder staged");
        }
    }

    private void AddImportPath(string path)
    {
        if (!File.Exists(path) && !Directory.Exists(path))
        {
            return;
        }

        var isDirectory = Directory.Exists(path);
        FileSystemInfo info = isDirectory ? new DirectoryInfo(path) : new FileInfo(path);
        var length = isDirectory ? 0 : ((FileInfo)info).Length;

        _imports.Insert(0, new StagedImport
        {
            File = info.Name,
            Source = SelectedSourceType(),
            Format = SourceFormat(info),
            Size = isDirectory ? "Folder" : FormatBytes(length),
            Imported = DateTime.Now.ToString("yyyy-MM-dd HH:mm"),
            Status = "Staged",
            Path = info.FullName,
        });
    }

    private string SelectedSourceType()
    {
        return SourceTypeCombo.SelectedItem is ComboBoxItem item
            ? item.Content.ToString() ?? "Unknown"
            : "Unknown";
    }

    private static string SourceFormat(FileSystemInfo item)
    {
        if (item is DirectoryInfo)
        {
            return item.Name.EndsWith(".gdb", StringComparison.OrdinalIgnoreCase) ? "File Geodatabase" : "Folder";
        }

        return item.Extension.TrimStart('.').ToLowerInvariant() switch
        {
            "csv" => "CSV",
            "xlsx" or "xls" => "Excel",
            "json" => "JSON",
            "geojson" => "GeoJSON",
            "shp" => "Esri Shapefile",
            "gpkg" => "GeoPackage",
            "kml" => "KML",
            "kmz" => "KMZ",
            "tab" => "MapInfo TAB",
            "mif" => "MapInfo MIF",
            "mid" => "MapInfo MID",
            "dxf" => "DXF",
            "dwg" => "DWG",
            "dxl" => "DXL",
            "dss" => "OpenDSS",
            "glm" => "GridLAB-D",
            "xml" => "XML / CIM",
            "rdf" => "CIM RDF",
            "raw" => "PSS/E RAW",
            "olr" => "ASPEN OneLiner",
            "cfg" => "COMTRADE CFG",
            "dat" => "COMTRADE DAT",
            "zip" => "Archive",
            var extension when !string.IsNullOrWhiteSpace(extension) => extension.ToUpperInvariant(),
            _ => "Unknown",
        };
    }

    private static string FormatBytes(long bytes)
    {
        if (bytes < 1024) return $"{bytes} B";
        if (bytes < 1024 * 1024) return $"{bytes / 1024.0:N1} KB";
        if (bytes < 1024 * 1024 * 1024) return $"{bytes / 1024.0 / 1024.0:N1} MB";
        return $"{bytes / 1024.0 / 1024.0 / 1024.0:N1} GB";
    }

    private void ExportManifest()
    {
        var manifest = new
        {
            project = "Recloser Optimisation",
            generatedAt = DateTimeOffset.UtcNow,
            scope = new
            {
                ingestion = "metadata staging only",
                processing = "not implemented",
                validation = "not implemented",
                optimisation = "not implemented",
                map = "live online tile basemap with empty future feeder overlay",
            },
            imports = _imports.ToArray(),
            adapters = _adapters.ToArray(),
            model = new
            {
                nodes = Array.Empty<object>(),
                lineSegments = Array.Empty<object>(),
                protectionDevices = Array.Empty<object>(),
                customerGroups = Array.Empty<object>(),
                outageEvents = Array.Empty<object>(),
                validationIssues = Array.Empty<object>(),
            },
            map = new
            {
                centerLat = _centerLat,
                centerLng = _centerLng,
                zoom = _zoom,
                layer = _activeLayer,
            },
        };

        SaveTextFile("Export project state", "recloser-optimisation-manifest.json", "JSON files|*.json|All files|*.*", JsonSerializer.Serialize(manifest, _jsonOptions));
    }

    private void ExportTemplate()
    {
        var lines = new[]
        {
            "source_group,platform,file_name,asset_id,parent_id,asset_type,feeder_id,latitude,longitude,voltage_kv,customers,notes",
            "GIS / mapping,Esri ArcGIS,,,,line_section,,,,,,",
            "Electrical model,OpenDSS,,,,node,,,,,,",
            "Protection settings,SEL / protection export,,,,recloser,,,,,,",
            "OMS / outage history,OMS,,,,outage_event,,,,,,",
        };

        SaveTextFile("Export import template", "recloser-import-template.csv", "CSV files|*.csv|All files|*.*", string.Join(Environment.NewLine, lines));
    }

    private void ExportGeoJson()
    {
        var geoJson = new
        {
            type = "FeatureCollection",
            name = "empty-feeder-overlay",
            features = Array.Empty<object>(),
        };

        SaveTextFile("Export empty feeder overlay", "empty-feeder-overlay.geojson", "GeoJSON files|*.geojson|JSON files|*.json|All files|*.*", JsonSerializer.Serialize(geoJson, _jsonOptions));
    }

    private void SaveTextFile(string title, string defaultFileName, string filter, string content)
    {
        var dialog = new SaveFileDialog
        {
            Title = title,
            FileName = defaultFileName,
            Filter = filter,
        };

        if (dialog.ShowDialog(this) == true)
        {
            File.WriteAllText(dialog.FileName, content);
            SetStatus($"Exported {Path.GetFileName(dialog.FileName)}");
        }
    }

    private void CenterMap()
    {
        _centerLat = -38.335;
        _centerLng = 175.165;
        _zoom = 10;
        RenderMap();
        SetStatus("Map centered on The Lines Company network area");
    }

    private void MapHostOnMouseWheel(object sender, MouseWheelEventArgs e)
    {
        _zoom = e.Delta > 0 ? Math.Min(18, _zoom + 1) : Math.Max(3, _zoom - 1);
        RenderMap();
        e.Handled = true;
    }

    private void MapHostOnMouseLeftButtonDown(object sender, MouseButtonEventArgs e)
    {
        _isDragging = true;
        _lastDragPoint = e.GetPosition(MapHost);
        MapHost.CaptureMouse();
    }

    private void MapHostOnMouseLeftButtonUp(object sender, MouseButtonEventArgs e)
    {
        StopMapDrag();
    }

    private void StopMapDrag()
    {
        if (!_isDragging)
        {
            return;
        }

        _isDragging = false;
        MapHost.ReleaseMouseCapture();
    }

    private void MapHostOnMouseMove(object sender, MouseEventArgs e)
    {
        if (!_isDragging)
        {
            return;
        }

        var point = e.GetPosition(MapHost);
        var dx = point.X - _lastDragPoint.X;
        var dy = point.Y - _lastDragPoint.Y;
        var scale = MapScale(_zoom);
        var centerX = WorldPixelX(_centerLng, _zoom) - dx;
        var centerY = Math.Clamp(WorldPixelY(_centerLat, _zoom) - dy, 0, scale);

        _centerLng = LongitudeFromWorldPixel(centerX, _zoom);
        _centerLat = Math.Clamp(LatitudeFromWorldPixel(centerY, _zoom), -85.0511, 85.0511);
        _lastDragPoint = point;
        RenderMap();
    }

    private void RenderMap()
    {
        if (MapHost.ActualWidth < 10 || MapHost.ActualHeight < 10)
        {
            return;
        }

        TileCanvas.Children.Clear();

        const double tileSize = 256.0;
        var tileCount = (int)Math.Pow(2, _zoom);
        var centerX = WorldPixelX(_centerLng, _zoom);
        var centerY = WorldPixelY(_centerLat, _zoom);
        var left = centerX - MapHost.ActualWidth / 2.0;
        var top = centerY - MapHost.ActualHeight / 2.0;
        var startTileX = (int)Math.Floor(left / tileSize);
        var endTileX = (int)Math.Floor((left + MapHost.ActualWidth) / tileSize);
        var startTileY = (int)Math.Floor(top / tileSize);
        var endTileY = (int)Math.Floor((top + MapHost.ActualHeight) / tileSize);

        for (var tx = startTileX; tx <= endTileX; tx++)
        {
            for (var ty = startTileY; ty <= endTileY; ty++)
            {
                if (ty < 0 || ty >= tileCount)
                {
                    continue;
                }

                var wrappedX = ((tx % tileCount) + tileCount) % tileCount;
                var image = new Image
                {
                    Width = tileSize,
                    Height = tileSize,
                    Stretch = Stretch.Fill,
                    Source = CreateTileBitmap(TileUrl(_activeLayer, wrappedX, ty, _zoom)),
                };

                Canvas.SetLeft(image, tx * tileSize - left);
                Canvas.SetTop(image, ty * tileSize - top);
                TileCanvas.Children.Add(image);
            }
        }

        MapReadout.Text = $"Lat {_centerLat:N4}, Lng {_centerLng:N4}, Zoom {_zoom}";
    }

    private static BitmapImage? CreateTileBitmap(string url)
    {
        try
        {
            var bitmap = new BitmapImage();
            bitmap.BeginInit();
            bitmap.UriSource = new Uri(url);
            bitmap.CacheOption = BitmapCacheOption.OnLoad;
            bitmap.CreateOptions = BitmapCreateOptions.IgnoreImageCache;
            bitmap.EndInit();
            return bitmap;
        }
        catch
        {
            return null;
        }
    }

    private static string TileUrl(string layer, int x, int y, int zoom)
    {
        var subdomains = new[] { "a", "b", "c" };
        var sub = subdomains[(x + y) % subdomains.Length];

        return layer switch
        {
            "Satellite" => $"https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{zoom}/{y}/{x}",
            "Terrain" => $"https://{sub}.tile.opentopomap.org/{zoom}/{x}/{y}.png",
            "Altitude" => $"https://server.arcgisonline.com/ArcGIS/rest/services/Elevation/World_Hillshade/MapServer/tile/{zoom}/{y}/{x}",
            _ => $"https://{sub}.tile.openstreetmap.org/{zoom}/{x}/{y}.png",
        };
    }

    private static double MapScale(int zoom) => 256.0 * Math.Pow(2, zoom);

    private static double WorldPixelX(double longitude, int zoom) => (longitude + 180.0) / 360.0 * MapScale(zoom);

    private static double WorldPixelY(double latitude, int zoom)
    {
        var sinY = Math.Sin(latitude * Math.PI / 180.0);
        sinY = Math.Clamp(sinY, -0.9999, 0.9999);
        return (0.5 - Math.Log((1 + sinY) / (1 - sinY)) / (4 * Math.PI)) * MapScale(zoom);
    }

    private static double LongitudeFromWorldPixel(double x, int zoom) => x / MapScale(zoom) * 360.0 - 180.0;

    private static double LatitudeFromWorldPixel(double y, int zoom)
    {
        var n = Math.PI - 2.0 * Math.PI * y / MapScale(zoom);
        return Math.Atan(Math.Sinh(n)) * 180.0 / Math.PI;
    }

    private void SetStatus(string message)
    {
        StatusText.Text = message;
    }
}
