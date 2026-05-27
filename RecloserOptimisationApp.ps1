Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Windows.Forms

$AppRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$AdapterConfigPath = Join-Path $AppRoot "config\import-adapters.json"
$AccountsConfigPath = Join-Path $AppRoot "config\prototype-accounts.json"
$ProjectStorePath = Join-Path $AppRoot "prototype-project-store.json"
$IconPath = Join-Path $AppRoot "assets\icon.ico"

$Xaml = @"
<Window
  xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  xmlns:lvc="http://schemas.livecharts.com/2.0/wpf"
  Title="Recloser Optimisation"
  Width="1500"
  Height="900"
  MinWidth="1180"
  MinHeight="720"
  WindowStartupLocation="CenterScreen"
  Background="#F7F9FC">
  <Window.Resources>
    <Style x:Key="NavButtonStyle" TargetType="Button">
      <Setter Property="Height" Value="38" />
      <Setter Property="Margin" Value="0,3,0,3" />
      <Setter Property="Padding" Value="12,0" />
      <Setter Property="HorizontalContentAlignment" Value="Left" />
      <Setter Property="Foreground" Value="#DBE9FB" />
      <Setter Property="Background" Value="Transparent" />
      <Setter Property="BorderBrush" Value="Transparent" />
      <Setter Property="BorderThickness" Value="0" />
      <Setter Property="FontWeight" Value="SemiBold" />
    </Style>
    <Style x:Key="PrimaryButtonStyle" TargetType="Button">
      <Setter Property="Height" Value="36" />
      <Setter Property="Padding" Value="14,0" />
      <Setter Property="Foreground" Value="White" />
      <Setter Property="Background" Value="#1559C9" />
      <Setter Property="BorderBrush" Value="#1559C9" />
      <Setter Property="BorderThickness" Value="1" />
      <Setter Property="FontWeight" Value="SemiBold" />
    </Style>
    <Style x:Key="SecondaryButtonStyle" TargetType="Button">
      <Setter Property="Height" Value="36" />
      <Setter Property="Padding" Value="14,0" />
      <Setter Property="Foreground" Value="#39475D" />
      <Setter Property="Background" Value="#FFFFFF" />
      <Setter Property="BorderBrush" Value="#DCE3EE" />
      <Setter Property="BorderThickness" Value="1" />
      <Setter Property="FontWeight" Value="SemiBold" />
    </Style>
    <Style x:Key="PanelBorderStyle" TargetType="Border">
      <Setter Property="Background" Value="#FFFFFF" />
      <Setter Property="BorderBrush" Value="#DCE3EE" />
      <Setter Property="BorderThickness" Value="1" />
      <Setter Property="CornerRadius" Value="8" />
      <Setter Property="Padding" Value="16" />
      <Setter Property="Margin" Value="0,0,14,14" />
    </Style>
    <Style x:Key="MetricTitleStyle" TargetType="TextBlock">
      <Setter Property="Foreground" Value="#667287" />
      <Setter Property="FontSize" Value="12" />
      <Setter Property="FontWeight" Value="SemiBold" />
    </Style>
    <Style x:Key="PageHeadingStyle" TargetType="TextBlock">
      <Setter Property="Foreground" Value="#132033" />
      <Setter Property="FontSize" Value="22" />
      <Setter Property="FontWeight" Value="SemiBold" />
    </Style>
    <Style x:Key="SmallMutedStyle" TargetType="TextBlock">
      <Setter Property="Foreground" Value="#667287" />
      <Setter Property="FontSize" Value="12" />
      <Setter Property="TextWrapping" Value="Wrap" />
    </Style>
  </Window.Resources>

  <Grid>
    <Grid.ColumnDefinitions>
      <ColumnDefinition Width="250" />
      <ColumnDefinition Width="*" />
    </Grid.ColumnDefinitions>

    <Border Grid.Column="0" Background="#07172C">
      <DockPanel LastChildFill="True" Margin="14">
        <StackPanel DockPanel.Dock="Top">
          <Border BorderBrush="#203852" BorderThickness="0,0,0,1" Padding="2,0,0,14" Margin="0,0,0,12">
            <StackPanel Orientation="Horizontal">
              <Border Width="38" Height="38" CornerRadius="8" BorderBrush="#3A5270" BorderThickness="1" Background="#FFFFFF" Padding="5" ClipToBounds="True">
                <Image x:Name="BrandIcon" Width="28" Height="28" Stretch="Uniform" HorizontalAlignment="Center" VerticalAlignment="Center" />
              </Border>
              <StackPanel Margin="10,0,0,0" VerticalAlignment="Center">
                <TextBlock Text="ROA" Foreground="White" FontWeight="Bold" />
                <TextBlock Text="Desktop prototype" Foreground="#A9BBD2" FontSize="12" />
              </StackPanel>
            </StackPanel>
          </Border>

          <Button x:Name="NavDashboard" Content="Dashboard" Tag="Dashboard" Style="{StaticResource NavButtonStyle}" />
          <Button x:Name="NavStorage" Content="Storage" Tag="Storage" Style="{StaticResource NavButtonStyle}" />
          <Button x:Name="NavProcessing" Content="Processing" Tag="Processing" Style="{StaticResource NavButtonStyle}" />
          <Button x:Name="NavModel" Content="Model Building" Tag="Model" Style="{StaticResource NavButtonStyle}" />
          <Button x:Name="NavMap" Content="Model Explorer" Tag="Map" Style="{StaticResource NavButtonStyle}" />
          <Button x:Name="NavValidation" Content="Validation" Tag="Validation" Style="{StaticResource NavButtonStyle}" />
          <Button x:Name="NavAnalysis" Content="Analysis" Tag="Analysis" Style="{StaticResource NavButtonStyle}" />
          <Button x:Name="NavOutages" Content="Outages" Tag="Outages" Style="{StaticResource NavButtonStyle}" />
          <Button x:Name="NavReports" Content="Reports" Tag="Reports" Style="{StaticResource NavButtonStyle}" />
        </StackPanel>

        <StackPanel DockPanel.Dock="Bottom">
          <Button x:Name="NavSettings" Content="Settings" Tag="Settings" Style="{StaticResource NavButtonStyle}" />
          <Border BorderBrush="#203852" BorderThickness="0,1,0,0" Padding="0,14,0,0" Margin="0,10,0,0">
            <StackPanel>
              <TextBlock Text="Active network/project" Foreground="#A9BBD2" FontSize="12" />
              <TextBlock x:Name="ProjectNameText" Text="Sign in to choose a project" Foreground="White" FontWeight="SemiBold" TextWrapping="Wrap" Margin="0,3,0,10" />
              <TextBlock x:Name="UserNameText" Text="Not signed in" Foreground="White" FontWeight="SemiBold" />
              <TextBlock Text="Local prototype session" Foreground="#A9BBD2" FontSize="12" />
            </StackPanel>
          </Border>
        </StackPanel>
      </DockPanel>
    </Border>

    <Grid Grid.Column="1">
      <Grid.RowDefinitions>
        <RowDefinition Height="72" />
        <RowDefinition Height="*" />
        <RowDefinition Height="34" />
      </Grid.RowDefinitions>

      <Border Grid.Row="0" Background="#FFFFFF" BorderBrush="#DCE3EE" BorderThickness="0,0,0,1">
        <Grid Margin="22,0">
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="*" />
            <ColumnDefinition Width="Auto" />
          </Grid.ColumnDefinitions>
          <StackPanel VerticalAlignment="Center">
            <TextBlock x:Name="ViewSubtitle" Text="Prototype" Foreground="#667287" FontSize="12" FontWeight="SemiBold" />
            <TextBlock x:Name="ViewTitle" Text="Dashboard" Foreground="#132033" FontSize="24" FontWeight="SemiBold" />
          </StackPanel>
          <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center">
            <ComboBox x:Name="ProjectNetworkCombo" Width="240" Height="36" Margin="0,0,8,0" IsEnabled="False" />
            <Button x:Name="NewProjectButton" Content="New Project" Style="{StaticResource SecondaryButtonStyle}" Margin="0,0,8,0" IsEnabled="False" />
            <Button x:Name="TopImportButton" Content="Import" Style="{StaticResource SecondaryButtonStyle}" Margin="0,0,8,0" IsEnabled="False" />
            <Button x:Name="ExportManifestButton" Content="Export State" Style="{StaticResource PrimaryButtonStyle}" Margin="0,0,8,0" IsEnabled="False" />
            <Button x:Name="ExportTemplateButton" Content="Export Template" Style="{StaticResource SecondaryButtonStyle}" IsEnabled="False" />
          </StackPanel>
        </Grid>
      </Border>

      <Grid Grid.Row="1" x:Name="PageHost">
        <ScrollViewer x:Name="DashboardPage" VerticalScrollBarVisibility="Auto">
          <StackPanel Margin="22">
            <Grid Margin="0,0,0,16">
              <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*" />
                <ColumnDefinition Width="Auto" />
              </Grid.ColumnDefinitions>
              <StackPanel>
                <TextBlock Text="Network overview" Style="{StaticResource SmallMutedStyle}" FontWeight="SemiBold" />
                <TextBlock Text="No feeder model loaded" Style="{StaticResource PageHeadingStyle}" />
              </StackPanel>
              <ComboBox Grid.Column="1" Width="190" Height="34" SelectedIndex="0">
                <ComboBoxItem Content="All feeders" />
                <ComboBoxItem Content="Active workspace" />
                <ComboBoxItem Content="Imported only" />
              </ComboBox>
            </Grid>

            <UniformGrid Columns="4" Margin="0,0,0,14">
              <Border Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Feeders" Style="{StaticResource MetricTitleStyle}" />
                  <TextBlock Text="0" FontSize="32" FontWeight="SemiBold" Foreground="#132033" />
                  <TextBlock Text="Awaiting GIS, DXL, DXF or CSV import" Style="{StaticResource SmallMutedStyle}" />
                </StackPanel>
              </Border>
              <Border Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Protection devices" Style="{StaticResource MetricTitleStyle}" />
                  <TextBlock Text="0" FontSize="32" FontWeight="SemiBold" Foreground="#132033" />
                  <TextBlock Text="Reclosers, fuses and breakers will appear here" Style="{StaticResource SmallMutedStyle}" />
                </StackPanel>
              </Border>
              <Border Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Customers represented" Style="{StaticResource MetricTitleStyle}" />
                  <TextBlock Text="0" FontSize="32" FontWeight="SemiBold" Foreground="#132033" />
                  <TextBlock Text="Customer groupings not imported" Style="{StaticResource SmallMutedStyle}" />
                </StackPanel>
              </Border>
              <Border Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Validation issues" Style="{StaticResource MetricTitleStyle}" />
                  <TextBlock Text="0" FontSize="32" FontWeight="SemiBold" Foreground="#132033" />
                  <TextBlock Text="No model has been validated yet" Style="{StaticResource SmallMutedStyle}" />
                </StackPanel>
              </Border>
            </UniformGrid>

            <Grid>
              <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*" />
                <ColumnDefinition Width="*" />
              </Grid.ColumnDefinitions>
              <Border Grid.Column="0" Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Workflow Status" FontSize="16" FontWeight="SemiBold" Foreground="#132033" />
                  <Border Background="#F7F9FC" BorderBrush="#C8D3E3" BorderThickness="1" CornerRadius="8" Padding="22" Margin="0,14,0,0">
                    <StackPanel HorizontalAlignment="Center">
                      <TextBlock Text="Ready for source data" FontWeight="SemiBold" Foreground="#132033" TextAlignment="Center" />
                      <TextBlock Text="Import utility exports first. Processing, validation and optimisation are reserved for the next build." Style="{StaticResource SmallMutedStyle}" TextAlignment="Center" Margin="0,6,0,0" />
                    </StackPanel>
                  </Border>
                </StackPanel>
              </Border>
              <Border Grid.Column="1" Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Reliability Indices" FontSize="16" FontWeight="SemiBold" Foreground="#132033" />
                  <UniformGrid Columns="3" Margin="0,14,0,0">
                    <Border Background="#F7F9FC" BorderBrush="#EDF1F7" BorderThickness="1" CornerRadius="8" Padding="14" Margin="0,0,8,0">
                      <StackPanel>
                        <TextBlock Text="SAIDI" Style="{StaticResource MetricTitleStyle}" />
                        <TextBlock Text="-" FontSize="26" FontWeight="SemiBold" />
                      </StackPanel>
                    </Border>
                    <Border Background="#F7F9FC" BorderBrush="#EDF1F7" BorderThickness="1" CornerRadius="8" Padding="14" Margin="0,0,8,0">
                      <StackPanel>
                        <TextBlock Text="SAIFI" Style="{StaticResource MetricTitleStyle}" />
                        <TextBlock Text="-" FontSize="26" FontWeight="SemiBold" />
                      </StackPanel>
                    </Border>
                    <Border Background="#F7F9FC" BorderBrush="#EDF1F7" BorderThickness="1" CornerRadius="8" Padding="14">
                      <StackPanel>
                        <TextBlock Text="Baseline" Style="{StaticResource MetricTitleStyle}" />
                        <TextBlock Text="-" FontSize="26" FontWeight="SemiBold" />
                      </StackPanel>
                    </Border>
                  </UniformGrid>
                </StackPanel>
              </Border>
            </Grid>

            <Border Style="{StaticResource PanelBorderStyle}" Margin="0,0,14,14">
              <StackPanel>
                <TextBlock Text="Recent Imports" FontSize="16" FontWeight="SemiBold" Foreground="#132033" Margin="0,0,0,12" />
                <DataGrid x:Name="DashboardImportsGrid" AutoGenerateColumns="False" HeadersVisibility="Column" CanUserAddRows="False" IsReadOnly="True" MinHeight="160">
                  <DataGrid.Columns>
                    <DataGridTextColumn Header="File" Binding="{Binding File}" Width="*" />
                    <DataGridTextColumn Header="Source" Binding="{Binding Source}" Width="150" />
                    <DataGridTextColumn Header="Format" Binding="{Binding Format}" Width="130" />
                    <DataGridTextColumn Header="Status" Binding="{Binding Status}" Width="110" />
                  </DataGrid.Columns>
                </DataGrid>
              </StackPanel>
            </Border>
          </StackPanel>
        </ScrollViewer>

        <ScrollViewer x:Name="StoragePage" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
          <StackPanel Margin="22">
            <Grid Margin="0,0,0,16">
              <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*" />
                <ColumnDefinition Width="Auto" />
              </Grid.ColumnDefinitions>
              <StackPanel>
                <TextBlock Text="File Storage" Style="{StaticResource SmallMutedStyle}" FontWeight="SemiBold" />
                <TextBlock Text="Imported utility, electrical modelling and GIS exports" Style="{StaticResource PageHeadingStyle}" />
              </StackPanel>
              <StackPanel Grid.Column="1" Orientation="Horizontal">
                <Button x:Name="ChooseFilesButton" Content="Import File" Style="{StaticResource PrimaryButtonStyle}" Margin="0,0,8,0" IsEnabled="False" />
                <Button x:Name="ChooseFolderButton" Content="Import Folder" Style="{StaticResource SecondaryButtonStyle}" Margin="0,0,8,0" IsEnabled="False" />
                <Button x:Name="ClearImportsButton" Content="Clear Staged" Style="{StaticResource SecondaryButtonStyle}" IsEnabled="False" />
              </StackPanel>
            </Grid>

            <Grid>
              <Grid.ColumnDefinitions>
                <ColumnDefinition Width="1.2*" />
                <ColumnDefinition Width="0.8*" />
              </Grid.ColumnDefinitions>
              <Border Grid.Column="0" Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Imported" FontSize="16" FontWeight="SemiBold" Foreground="#132033" />
                  <Grid Margin="0,12,0,14">
                    <Grid.ColumnDefinitions>
                      <ColumnDefinition Width="180" />
                      <ColumnDefinition Width="*" />
                    </Grid.ColumnDefinitions>
                    <TextBlock Text="File Contents" VerticalAlignment="Center" Foreground="#667287" FontWeight="SemiBold" />
                    <ComboBox x:Name="SourceTypeCombo" Grid.Column="1" Height="34" SelectedIndex="0">
                      <ComboBoxItem Content="GIS / mapping" />
                      <ComboBoxItem Content="Electrical model" />
                      <ComboBoxItem Content="Protection settings" />
                      <ComboBoxItem Content="SCADA / ADMS" />
                      <ComboBoxItem Content="OMS / outage history" />
                      <ComboBoxItem Content="Customer / load" />
                      <ComboBoxItem Content="Asset registry" />
                    </ComboBox>
                  </Grid>
                  <Border Background="#F7F9FC" BorderBrush="#B7C5D9" BorderThickness="1" CornerRadius="8" Padding="24" MinHeight="160">
                    <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center">
                      <TextBlock Text="No files to show" FontWeight="SemiBold" Foreground="#132033" TextAlignment="Center" />
                    </StackPanel>
                  </Border>
                  <TextBlock Text="Supported file types include CSV, XLSX, JSON, GeoJSON, SHP packages, GDB folders, GPKG, KML/KMZ, TAB/MIF, DXF, DXL, DSS, GLM, XML/CIM, RAW, OLR, COMTRADE CFG/DAT and platform export archives." Style="{StaticResource SmallMutedStyle}" Margin="0,12,0,0" />
                </StackPanel>
              </Border>

              <Border Grid.Column="1" Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Import Adapter Plan" FontSize="16" FontWeight="SemiBold" Foreground="#132033" Margin="0,0,0,8" />
                  <TextBlock Text="ROA is designed to accept common engineering program exports. If the file type is unrecognized, an adapter plan can be created with the following template" Style="{StaticResource SmallMutedStyle}" Margin="0,0,0,12" />
                  
                  <DataGrid x:Name="AdapterSummaryGrid" AutoGenerateColumns="False" HeadersVisibility="Column" CanUserAddRows="False" IsReadOnly="True" MinHeight="260">
                    <DataGrid.Columns>
                      <DataGridTextColumn Header="Platform" Binding="{Binding platform}" Width="*" />
                      <DataGridTextColumn Header="Formats" Binding="{Binding formats}" Width="1.2*" />
                      <DataGridTextColumn Header="Status" Binding="{Binding status}" Width="95" />
                    </DataGrid.Columns>
                  </DataGrid>
                </StackPanel>
              </Border>
            </Grid>

            <Border Style="{StaticResource PanelBorderStyle}">
              <StackPanel>
                <Grid Margin="0,0,0,12">
                  <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*" />
                    <ColumnDefinition Width="Auto" />
                  </Grid.ColumnDefinitions>
                  <TextBlock Text="File History" FontSize="16" FontWeight="SemiBold" Foreground="#132033" />
                  <Button x:Name="ExportFileHistoryButton" Grid.Column="1" Content="Export File History" Style="{StaticResource SecondaryButtonStyle}" IsEnabled="False" />
                </Grid>
                <DataGrid x:Name="ImportsGrid" AutoGenerateColumns="False" HeadersVisibility="Column" CanUserAddRows="False" IsReadOnly="True" MinHeight="230">
                  <DataGrid.Columns>
                    <DataGridTextColumn Header="File or folder" Binding="{Binding File}" Width="*" />
                    <DataGridTextColumn Header="Source" Binding="{Binding Source}" Width="170" />
                    <DataGridTextColumn Header="Format" Binding="{Binding Format}" Width="150" />
                    <DataGridTextColumn Header="Size" Binding="{Binding Size}" Width="110" />
                    <DataGridTextColumn Header="Imported" Binding="{Binding Imported}" Width="150" />
                    <DataGridTextColumn Header="Status" Binding="{Binding Status}" Width="110" />
                  </DataGrid.Columns>
                </DataGrid>
              </StackPanel>
            </Border>
          </StackPanel>
        </ScrollViewer>

        <ScrollViewer x:Name="ProcessingPage" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
          <StackPanel Margin="22">
            <Grid Margin="0,0,0,16">
              <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*" />
                <ColumnDefinition Width="Auto" />
              </Grid.ColumnDefinitions>
              <StackPanel>
                <TextBlock Text="Pipeline" Style="{StaticResource SmallMutedStyle}" FontWeight="SemiBold" />
                <TextBlock Text="Processing queue" Style="{StaticResource PageHeadingStyle}" />
              </StackPanel>
              <Button Grid.Column="1" Content="Run Pipeline" Style="{StaticResource PrimaryButtonStyle}" IsEnabled="False" HorizontalAlignment="Right" VerticalAlignment="Top" />
            </Grid>
            <UniformGrid Columns="4">
              <Border Style="{StaticResource PanelBorderStyle}"><StackPanel><TextBlock Text="1. Identify datasets" FontWeight="SemiBold" /><TextBlock Text="Source detection and coordinate system matching will be connected later." Style="{StaticResource SmallMutedStyle}" Margin="0,8,0,0" /></StackPanel></Border>
              <Border Style="{StaticResource PanelBorderStyle}"><StackPanel><TextBlock Text="2. Attribute mapping" FontWeight="SemiBold" /><TextBlock Text="Field names, units and IDs will map into the internal schema." Style="{StaticResource SmallMutedStyle}" Margin="0,8,0,0" /></StackPanel></Border>
              <Border Style="{StaticResource PanelBorderStyle}"><StackPanel><TextBlock Text="3. Network graph build" FontWeight="SemiBold" /><TextBlock Text="Nodes, spans, devices and customer groupings will form a directed model." Style="{StaticResource SmallMutedStyle}" Margin="0,8,0,0" /></StackPanel></Border>
              <Border Style="{StaticResource PanelBorderStyle}"><StackPanel><TextBlock Text="4. Validation handoff" FontWeight="SemiBold" /><TextBlock Text="Connectivity, missing attributes and feasibility checks will publish issues." Style="{StaticResource SmallMutedStyle}" Margin="0,8,0,0" /></StackPanel></Border>
            </UniformGrid>
            <Border Style="{StaticResource PanelBorderStyle}">
              <TextBlock Text="Processing is  not implemented yet. " TextWrapping="Wrap" Foreground="#667287" />
            </Border>
          </StackPanel>
        </ScrollViewer>

        <ScrollViewer x:Name="ModelPage" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
          <StackPanel Margin="22">
            <Grid Margin="0,0,0,16">
              <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*" />
                <ColumnDefinition Width="Auto" />
              </Grid.ColumnDefinitions>
              <StackPanel>
                <TextBlock Text="Internal network model" Style="{StaticResource SmallMutedStyle}" FontWeight="SemiBold" />
                <TextBlock Text="Model building" Style="{StaticResource PageHeadingStyle}" />
              </StackPanel>
              <Button x:Name="ExportGeoJsonButton" Grid.Column="1" Content="Export Empty GeoJSON" Style="{StaticResource SecondaryButtonStyle}" HorizontalAlignment="Right" VerticalAlignment="Top" />
            </Grid>
            <Grid>
              <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*" />
                <ColumnDefinition Width="*" />
              </Grid.ColumnDefinitions>
              <Border Grid.Column="0" Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Model versions" FontSize="16" FontWeight="SemiBold" Foreground="#132033" />
                  <TextBlock Text="No model versions." Style="{StaticResource SmallMutedStyle}" Margin="0,12,0,0" />
                </StackPanel>
              </Border>
              <Border Grid.Column="1" Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Data Correction Scheme" FontSize="16" FontWeight="SemiBold" Foreground="#132033" />
                  <TextBlock Text="nodes, line_segments, protection_devices, customers, outage_events, validation_issues" Style="{StaticResource SmallMutedStyle}" Margin="0,12,0,0" />
                </StackPanel>
              </Border>
            </Grid>
          </StackPanel>
        </ScrollViewer>

        <Grid x:Name="MapPage" Visibility="Collapsed">
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="292" />
            <ColumnDefinition Width="*" />
            <ColumnDefinition Width="300" />
          </Grid.ColumnDefinitions>
          <Border Grid.Column="0" Background="#FFFFFF" BorderBrush="#DCE3EE" BorderThickness="0,0,1,0" Padding="16">
            <StackPanel>
              <TextBlock Text="Explorer" FontSize="16" FontWeight="SemiBold" Foreground="#132033" />
              <TextBox Height="34" Margin="0,12,0,14" Text="Search assets..." Foreground="#667287" />
              <Button Content="Feeders (0)" Style="{StaticResource SecondaryButtonStyle}" HorizontalContentAlignment="Left" Margin="0,0,0,6" />
              <Button Content="Protection devices (0)" Style="{StaticResource SecondaryButtonStyle}" HorizontalContentAlignment="Left" Margin="0,0,0,6" />
              <Button Content="Line sections (0)" Style="{StaticResource SecondaryButtonStyle}" HorizontalContentAlignment="Left" Margin="0,0,0,6" />
              <Button Content="Customer groups (0)" Style="{StaticResource SecondaryButtonStyle}" HorizontalContentAlignment="Left" />
            </StackPanel>
          </Border>

          <Grid x:Name="MapHost" Grid.Column="1" Background="#DDE7EF" ClipToBounds="True">
            <Canvas x:Name="TileCanvas" Background="#DDE7EF" />
            <Border HorizontalAlignment="Left" VerticalAlignment="Top" Margin="14" Background="#F9FFFFFF" BorderBrush="#DCE3EE" BorderThickness="1" CornerRadius="8" Padding="8">
              <StackPanel Orientation="Horizontal">
                <ComboBox x:Name="MapLayerCombo" Width="150" Height="34" SelectedIndex="0" Margin="0,0,8,0">
                  <ComboBoxItem Content="Street" />
                  <ComboBoxItem Content="Satellite" />
                  <ComboBoxItem Content="Terrain" />
                  <ComboBoxItem Content="Altitude" />
                </ComboBox>
                <Button x:Name="CenterMapButton" Content="Center" Style="{StaticResource SecondaryButtonStyle}" Margin="0,0,8,0" />
                <CheckBox x:Name="OverlayToggle" Content="Future overlay" IsChecked="True" VerticalAlignment="Center" />
              </StackPanel>
            </Border>
            <Border x:Name="MapEmptyBadge" HorizontalAlignment="Right" VerticalAlignment="Bottom" Margin="0,0,16,18" Width="320" Background="#F9FFFFFF" BorderBrush="#DCE3EE" BorderThickness="1" CornerRadius="8" Padding="12">
              <StackPanel>
                <TextBlock Text="Feeder overlay empty" Foreground="#132033" FontWeight="SemiBold" />
                <TextBlock Text="Imported assets will be drawn over the selected basemap in a future build." Style="{StaticResource SmallMutedStyle}" Margin="0,4,0,0" />
              </StackPanel>
            </Border>
            <Border HorizontalAlignment="Left" VerticalAlignment="Bottom" Margin="16,0,0,18" Background="#F9FFFFFF" BorderBrush="#DCE3EE" BorderThickness="1" CornerRadius="8" Padding="10,7">
              <TextBlock x:Name="MapReadout" Text="Lat -38.3350, Lng 175.1650, Zoom 10" Foreground="#39475D" FontWeight="SemiBold" FontSize="12" />
            </Border>
          </Grid>

          <Border Grid.Column="2" Background="#FFFFFF" BorderBrush="#DCE3EE" BorderThickness="1,0,0,0" Padding="16">
            <StackPanel>
              <TextBlock Text="Selected Asset" FontSize="16" FontWeight="SemiBold" Foreground="#132033" />
              <Border Background="#F7F9FC" BorderBrush="#C8D3E3" BorderThickness="1" CornerRadius="8" Padding="18" Margin="0,14,0,0">
                <StackPanel>
                  <TextBlock Text="No asset selected" FontWeight="SemiBold" Foreground="#132033" />
                  <TextBlock Text="Click map assets later. The basemap is connected now; feeder features and asset details will appear once processing exists." Style="{StaticResource SmallMutedStyle}" Margin="0,8,0,0" />
                </StackPanel>
              </Border>
            </StackPanel>
          </Border>
        </Grid>

        <ScrollViewer x:Name="ValidationPage" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
          <StackPanel Margin="22">
            <TextBlock Text="Quality gates" Style="{StaticResource SmallMutedStyle}" FontWeight="SemiBold" />
            <TextBlock Text="Validation" Style="{StaticResource PageHeadingStyle}" Margin="0,0,0,16" />
            <UniformGrid Columns="4">
              <Border Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Connectivity" Style="{StaticResource MetricTitleStyle}" />
                  <TextBlock Text="-" FontSize="28" FontWeight="SemiBold" />
                </StackPanel>
              </Border>
              <Border Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Attribute completeness" Style="{StaticResource MetricTitleStyle}" />
                  <TextBlock Text="-" FontSize="28" FontWeight="SemiBold" />
                </StackPanel>
              </Border>
              <Border Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Spatial consistency" Style="{StaticResource MetricTitleStyle}" />
                  <TextBlock Text="-" FontSize="28" FontWeight="SemiBold" />
                </StackPanel>
              </Border>
              <Border Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Placement feasibility" Style="{StaticResource MetricTitleStyle}" />
                  <TextBlock Text="-" FontSize="28" FontWeight="SemiBold" />
                </StackPanel>
              </Border>
            </UniformGrid>
            <Border Style="{StaticResource PanelBorderStyle}" Margin="0,16,0,0">
              <StackPanel>
                <TextBlock Text="Validation Radar"
                          FontSize="16"
                          FontWeight="SemiBold"
                          Margin="0,0,0,10"/>
                <Grid>
                  <Canvas x:Name="RadarCanvas" Height="320"/>
                </Grid>
              </StackPanel>
            </Border>
            <Border Style="{StaticResource PanelBorderStyle}" Margin="0,16,0,0">
              <TextBlock Text="Validation rules are placeholders. Future routines will flag disconnected spans, missing device attributes, coordinate problems and inferred data."
                        TextWrapping="Wrap"
                        Foreground="#667287" />
            </Border>
          </StackPanel>
        </ScrollViewer>

        <ScrollViewer x:Name="AnalysisPage" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
          <StackPanel Margin="22"><TextBlock Text="Reliability studies" Style="{StaticResource SmallMutedStyle}" FontWeight="SemiBold" /><TextBlock Text="Analysis" Style="{StaticResource PageHeadingStyle}" Margin="0,0,0,16" /><Grid><Grid.ColumnDefinitions><ColumnDefinition Width="*" /><ColumnDefinition Width="*" /></Grid.ColumnDefinitions><Border Grid.Column="0" Style="{StaticResource PanelBorderStyle}"><StackPanel><TextBlock Text="Study setup" FontSize="16" FontWeight="SemiBold" /><TextBlock Text="Scenario: Baseline feeder model" Style="{StaticResource SmallMutedStyle}" Margin="0,12,0,0" /><TextBlock Text="Objective: SAIDI / SAIFI reduction" Style="{StaticResource SmallMutedStyle}" /></StackPanel></Border><Border Grid.Column="1" Style="{StaticResource PanelBorderStyle}"><TextBlock Text="No analysis results. Reliability plots and optimisation comparisons will populate after algorithms are connected." TextWrapping="Wrap" Foreground="#667287" /></Border></Grid></StackPanel>
        </ScrollViewer>

        <ScrollViewer x:Name="OutagesPage" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
          <StackPanel Margin="22"><TextBlock Text="Historical performance" Style="{StaticResource SmallMutedStyle}" FontWeight="SemiBold" /><TextBlock Text="Outages" Style="{StaticResource PageHeadingStyle}" Margin="0,0,0,16" /><Border Style="{StaticResource PanelBorderStyle}"><TextBlock Text="No outage history imported. OMS extracts will eventually support baseline reliability calculations and feeder section comparisons." TextWrapping="Wrap" Foreground="#667287" /></Border></StackPanel>
        </ScrollViewer>

        <ScrollViewer x:Name="ReportsPage" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
          <StackPanel Margin="22"><TextBlock Text="Outputs" Style="{StaticResource SmallMutedStyle}" FontWeight="SemiBold" /><TextBlock Text="Reports" Style="{StaticResource PageHeadingStyle}" Margin="0,0,0,16" /><Border Style="{StaticResource PanelBorderStyle}"><DataGrid AutoGenerateColumns="False" HeadersVisibility="Column" CanUserAddRows="False" IsReadOnly="True" MinHeight="220" x:Name="ReportsGrid"><DataGrid.Columns><DataGridTextColumn Header="Report" Binding="{Binding Report}" Width="*" /><DataGridTextColumn Header="Category" Binding="{Binding Category}" Width="160" /><DataGridTextColumn Header="Status" Binding="{Binding Status}" Width="150" /></DataGrid.Columns></DataGrid></Border></StackPanel>
        </ScrollViewer>

        <ScrollViewer x:Name="SettingsPage" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
          <StackPanel Margin="22">
            <TextBlock Text="Workspace" Style="{StaticResource SmallMutedStyle}" FontWeight="SemiBold" />
            <TextBlock Text="Settings" Style="{StaticResource PageHeadingStyle}" Margin="0,0,0,16" />
            <Grid>
              <Grid.ColumnDefinitions><ColumnDefinition Width="*" /><ColumnDefinition Width="*" /></Grid.ColumnDefinitions>
              <Border Grid.Column="0" Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Map defaults" FontSize="16" FontWeight="SemiBold" Foreground="#132033" />
                  <TextBlock Text="Default center: The Lines Company network area" Style="{StaticResource SmallMutedStyle}" Margin="0,12,0,0" />
                  <TextBlock Text="Default basemap: Street" Style="{StaticResource SmallMutedStyle}" />
                </StackPanel>
              </Border>
              <Border Grid.Column="1" Style="{StaticResource PanelBorderStyle}">
                <StackPanel>
                  <TextBlock Text="Prototype scope" FontSize="16" FontWeight="SemiBold" Foreground="#132033" />
                  <TextBlock Text="Implemented: desktop navigation, native import staging, native export saves and live tile basemaps." Style="{StaticResource SmallMutedStyle}" Margin="0,12,0,0" />
                  <TextBlock Text="Pending: parsing, data normalisation, graph construction, validation rules and optimisation." Style="{StaticResource SmallMutedStyle}" />
                </StackPanel>
              </Border>
            </Grid>
          </StackPanel>
        </ScrollViewer>
      </Grid>

      <Border Grid.Row="2" Background="#FFFFFF" BorderBrush="#DCE3EE" BorderThickness="0,1,0,0">
        <TextBlock x:Name="StatusText" Text="Ready" VerticalAlignment="Center" Margin="22,0" Foreground="#667287" FontSize="12" />
      </Border>
    </Grid>

    <Grid x:Name="LoginOverlay" Grid.ColumnSpan="2" Background="#D907172C">
      <Border Width="460" Background="#FFFFFF" BorderBrush="#DCE3EE" BorderThickness="1" CornerRadius="8" Padding="24" HorizontalAlignment="Center" VerticalAlignment="Center">
        <StackPanel>
          <Image x:Name="LoginLogo" Width="82" Height="82" Stretch="Uniform" HorizontalAlignment="Center" Margin="0,0,0,12" />
          <TextBlock Text="Sign in to ROA" Foreground="#132033" FontSize="24" FontWeight="SemiBold" HorizontalAlignment="Center" />
          <TextBlock Text="Enter a registered local prototype account. Project files are hidden until the account is accepted." Foreground="#667287" TextWrapping="Wrap" TextAlignment="Center" Margin="0,8,0,20" />

          <TextBlock Text="User name" Foreground="#667287" FontSize="12" FontWeight="SemiBold" Margin="0,0,0,6" />
          <TextBox x:Name="SignInNameBox" Height="36" Text="Jack Satherley" Margin="0,0,0,14" />

          <Button x:Name="SignInButton" Content="Sign In" Style="{StaticResource PrimaryButtonStyle}" Height="40" />
          <TextBlock Text="Prototype account: Jack Satherley. This is local access control only; real authentication can be added later." Foreground="#667287" TextWrapping="Wrap" TextAlignment="Center" FontSize="12" Margin="0,14,0,0" />
        </StackPanel>
      </Border>
    </Grid>
  </Grid>
</Window>
"@

$Reader = New-Object System.Xml.XmlNodeReader ([xml]$Xaml)
$Window = [Windows.Markup.XamlReader]::Load($Reader)

function Get-Control {
  param([string]$Name)
  return $Window.FindName($Name)
}

$ViewTitle = Get-Control "ViewTitle"
$ViewSubtitle = Get-Control "ViewSubtitle"
$StatusText = Get-Control "StatusText"
$TopImportButton = Get-Control "TopImportButton"
$ExportManifestButton = Get-Control "ExportManifestButton"
$ExportTemplateButton = Get-Control "ExportTemplateButton"
$ChooseFilesButton = Get-Control "ChooseFilesButton"
$ChooseFolderButton = Get-Control "ChooseFolderButton"
$ClearImportsButton = Get-Control "ClearImportsButton"
$ExportFileHistoryButton = Get-Control "ExportFileHistoryButton"
$ImportsGrid = Get-Control "ImportsGrid"
$DashboardImportsGrid = Get-Control "DashboardImportsGrid"
$AdapterSummaryGrid = Get-Control "AdapterSummaryGrid"
$ReportsGrid = Get-Control "ReportsGrid"
$SourceTypeCombo = Get-Control "SourceTypeCombo"
$MapHost = Get-Control "MapHost"
$TileCanvas = Get-Control "TileCanvas"
$MapReadout = Get-Control "MapReadout"
$RadarHost = Get-Control "RadarHost"
$RadarCanvas = Get-Control "RadarCanvas"
$RadarReadout = Get-Control "RadarReadout"
$MapLayerCombo = Get-Control "MapLayerCombo"
$OverlayToggle = Get-Control "OverlayToggle"
$MapEmptyBadge = Get-Control "MapEmptyBadge"
$BrandIcon = Get-Control "BrandIcon"
$LoginLogo = Get-Control "LoginLogo"
$LoginOverlay = Get-Control "LoginOverlay"
$SignInNameBox = Get-Control "SignInNameBox"
$SignInProjectCombo = Get-Control "SignInProjectCombo"
$SignInButton = Get-Control "SignInButton"
$ProjectNetworkCombo = Get-Control "ProjectNetworkCombo"
$NewProjectButton = Get-Control "NewProjectButton"
$ProjectNameText = Get-Control "ProjectNameText"
$UserNameText = Get-Control "UserNameText"

$script:Imports = New-Object "System.Collections.ObjectModel.ObservableCollection[object]"
$script:Adapters = New-Object "System.Collections.ObjectModel.ObservableCollection[object]"
$script:Reports = New-Object "System.Collections.ObjectModel.ObservableCollection[object]"
$script:Pages = @{}
$script:NavButtons = @()
$script:PrototypeAccounts = @()
$script:ProjectStore = @()
$script:IsAuthenticated = $false
$script:IsRefreshingProjects = $false
$script:CurrentAccount = $null
$script:MapState = @{
  CenterLat = -38.335
  CenterLng = 175.165
  Zoom = 10
  Layer = "Street"
  Dragging = $false
  LastPoint = $null
  TileSize = 256.0
}
$script:CurrentUserName = "Not signed in"
$script:CurrentProjectName = ""

foreach ($name in @("Dashboard","Storage","Processing","Model","Map","Validation","Analysis","Outages","Reports","Settings")) {
  $script:Pages[$name] = Get-Control "$($name)Page"
  $button = Get-Control "Nav$name"
  if ($button) {
    $script:NavButtons += $button
  }
}

$ImportsGrid.ItemsSource = $script:Imports
$DashboardImportsGrid.ItemsSource = $script:Imports
$AdapterSummaryGrid.ItemsSource = $script:Adapters
$ReportsGrid.ItemsSource = $script:Reports

function Set-Status {
  param([string]$Message)
  $StatusText.Text = $Message
}

function Get-Brush {
  param([string]$Color)
  return (New-Object Windows.Media.BrushConverter).ConvertFromString($Color)
}

function Show-Page {
  param([string]$Name)

  foreach ($key in $script:Pages.Keys) {
    if ($script:Pages[$key]) {
      $script:Pages[$key].Visibility = if ($key -eq $Name) { "Visible" } else { "Collapsed" }
    }
  }

  foreach ($button in $script:NavButtons) {
    if ([string]$button.Tag -eq $Name) {
      $button.Background = Get-Brush "#1D5ECF"
      $button.Foreground = Get-Brush "#FFFFFF"
    } else {
      $button.Background = Get-Brush "Transparent"
      $button.Foreground = Get-Brush "#DBE9FB"
    }
  }

  $titles = @{
    Dashboard = @("Prototype","Dashboard")
    Storage = @("File Storage","Storage")
    Processing = @("Pipeline","Processing")
    Model = @("Internal network model","Model Building")
    Map = @("Geospatial workspace","Model Explorer")
    Validation = @("Quality gates","Validation")
    Analysis = @("Reliability studies","Analysis")
    Outages = @("Historical performance","Outages")
    Reports = @("Outputs","Reports")
    Settings = @("Workspace","Settings")
  }

  $ViewSubtitle.Text = $titles[$Name][0]
  $ViewTitle.Text = $titles[$Name][1]
  Set-Status "Viewing $($titles[$Name][1])"

  if ($Name -eq "Map") {
    $Window.Dispatcher.BeginInvoke([Action]{ Render-Map }) | Out-Null
  }


}

function Get-AdapterCatalogue {
  if (Test-Path -LiteralPath $AdapterConfigPath) {
    return Get-Content -LiteralPath $AdapterConfigPath -Raw | ConvertFrom-Json
  }

  return @(
    [pscustomobject]@{ category = "GIS"; platform = "Esri ArcGIS"; formats = "SHP, FileGDB, GeoJSON, REST"; status = "Planned"; purpose = "Spatial network and asset layers" },
    [pscustomobject]@{ category = "Electrical model"; platform = "OpenDSS"; formats = "DSS, CSV"; status = "Planned"; purpose = "Feeder model exchange" }
  )
}

function Load-Adapters {
  $script:Adapters.Clear()
  foreach ($adapter in (Get-AdapterCatalogue)) {
    $script:Adapters.Add($adapter)
  }
}

function Load-Reports {
  $script:Reports.Clear()
  foreach ($report in @(
    [pscustomobject]@{ Report = "Network model summary"; Category = "Model"; Status = "Unavailable" },
    [pscustomobject]@{ Report = "SAIDI / SAIFI comparison"; Category = "Analysis"; Status = "Unavailable" },
    [pscustomobject]@{ Report = "Validation issue register"; Category = "Validation"; Status = "Unavailable" }
  )) {
    $script:Reports.Add($report)
  }
}

function Load-Branding {
  if (-not $BrandIcon -or -not (Test-Path -LiteralPath $IconPath)) {
    return
  }

  $bitmap = New-Object Windows.Media.Imaging.BitmapImage
  $bitmap.BeginInit()
  $bitmap.UriSource = [Uri]$IconPath
  $bitmap.CacheOption = [Windows.Media.Imaging.BitmapCacheOption]::OnLoad
  $bitmap.EndInit()
  $BrandIcon.Source = $bitmap
  if ($LoginLogo) {
    $LoginLogo.Source = $bitmap
  }
}

function Get-ComboText {
  param($ComboBox)

  if (-not $ComboBox -or -not $ComboBox.SelectedItem) {
    return ""
  }

  if ($ComboBox.SelectedItem -is [Windows.Controls.ComboBoxItem]) {
    return [string]$ComboBox.SelectedItem.Content
  }

  return [string]$ComboBox.SelectedItem
}

function Get-PropertyValue {
  param(
    $Object,
    [string]$Name,
    $Default = $null
  )

  if ($Object -and $Object.PSObject.Properties[$Name]) {
    return $Object.PSObject.Properties[$Name].Value
  }

  return $Default
}

function Normalize-AccountName {
  param([string]$Name)

  if ([string]::IsNullOrWhiteSpace($Name)) {
    return ""
  }

  return $Name.Trim().ToLowerInvariant()
}

function Load-PrototypeAccounts {
  $script:PrototypeAccounts = @()

  if (Test-Path -LiteralPath $AccountsConfigPath) {
    $raw = Get-Content -LiteralPath $AccountsConfigPath -Raw | ConvertFrom-Json
    $accounts = Get-PropertyValue $raw "accounts" @()
    if ($accounts) {
      $script:PrototypeAccounts = @($accounts)
    }
  }

  if (-not $script:PrototypeAccounts -or $script:PrototypeAccounts.Count -eq 0) {
    $script:PrototypeAccounts = @(
      [pscustomobject]@{
        accountName = "Jack Satherley"
        displayName = "Jack Satherley"
        role = "Research prototype owner"
        aliases = @("jack.satherley")
      }
    )
  }
}

function Find-PrototypeAccount {
  param([string]$Name)

  $candidate = Normalize-AccountName $Name
  foreach ($account in @($script:PrototypeAccounts)) {
    $accountName = Normalize-AccountName (Get-PropertyValue $account "accountName")
    $displayName = Normalize-AccountName (Get-PropertyValue $account "displayName")
    if ($candidate -eq $accountName -or $candidate -eq $displayName) {
      return $account
    }

    $aliases = @(Get-PropertyValue $account "aliases" @())
    foreach ($alias in $aliases) {
      if ($candidate -eq (Normalize-AccountName ([string]$alias))) {
        return $account
      }
    }
  }

  return $null
}

function New-ProjectRecord {
  param(
    [string]$Name,
    [string]$Owner
  )

  return [pscustomobject]@{
    name = $Name
    owner = $Owner
    createdAt = (Get-Date).ToUniversalTime().ToString("o")
    imports = @()
  }
}

function Load-ProjectStore {
  $script:ProjectStore = @()

  if (Test-Path -LiteralPath $ProjectStorePath) {
    try {
      $raw = Get-Content -LiteralPath $ProjectStorePath -Raw | ConvertFrom-Json
      $projects = Get-PropertyValue $raw "projects" @()
      if ($projects) {
        $script:ProjectStore = @($projects)
      }
    } catch {
      $script:ProjectStore = @()
    }
  }

  if (-not $script:ProjectStore -or $script:ProjectStore.Count -eq 0) {
    $script:ProjectStore = @(
      (New-ProjectRecord "King Country feeder study" "Jack Satherley"),
      (New-ProjectRecord "Taumarunui network" "Jack Satherley"),
      (New-ProjectRecord "Te Kuiti network" "Jack Satherley"),
      (New-ProjectRecord "Waitomo rural feeders" "Jack Satherley")
    )
    Save-ProjectStore
  }

  foreach ($project in @($script:ProjectStore)) {
    if (-not $project.PSObject.Properties["imports"]) {
      $project | Add-Member -NotePropertyName "imports" -NotePropertyValue @()
    }
  }
}

function Save-ProjectStore {
  $store = [pscustomobject]@{
    version = 1
    updatedAt = (Get-Date).ToUniversalTime().ToString("o")
    projects = @($script:ProjectStore)
  }

  $json = $store | ConvertTo-Json -Depth 10
  [System.IO.File]::WriteAllText($ProjectStorePath, $json, [System.Text.Encoding]::UTF8)
}

function Get-CurrentOwnerName {
  if ($script:CurrentAccount) {
    $displayName = Get-PropertyValue $script:CurrentAccount "displayName"
    if (-not [string]::IsNullOrWhiteSpace($displayName)) {
      return $displayName
    }
  }

  return $script:CurrentUserName
}

function Get-AuthorizedProjects {
  $owner = Get-CurrentOwnerName
  return @($script:ProjectStore | Where-Object { (Get-PropertyValue $_ "owner") -eq $owner })
}

function Get-ProjectRecord {
  param([string]$ProjectName)

  $owner = Get-CurrentOwnerName
  foreach ($project in @($script:ProjectStore)) {
    if ((Get-PropertyValue $project "owner") -eq $owner -and (Get-PropertyValue $project "name") -eq $ProjectName) {
      return $project
    }
  }

  return $null
}

function Refresh-ProjectSelectors {
  param([string]$PreferredProjectName)

  $script:IsRefreshingProjects = $true
  $projects = Get-AuthorizedProjects

  foreach ($combo in @($ProjectNetworkCombo, $SignInProjectCombo)) {
    if (-not $combo) { continue }
    $combo.Items.Clear()
    foreach ($project in $projects) {
      $item = New-Object Windows.Controls.ComboBoxItem
      $item.Content = Get-PropertyValue $project "name"
      $combo.Items.Add($item) | Out-Null
    }

    if ($combo.Items.Count -gt 0) {
      $selectionIndex = 0
      if (-not [string]::IsNullOrWhiteSpace($PreferredProjectName)) {
        for ($i = 0; $i -lt $combo.Items.Count; $i++) {
          if ([string]$combo.Items[$i].Content -eq $PreferredProjectName) {
            $selectionIndex = $i
            break
          }
        }
      }
      $combo.SelectedIndex = $selectionIndex
    }
  }

  $script:IsRefreshingProjects = $false
}

function Load-ProjectImports {
  $script:Imports.Clear()
  $project = Get-ProjectRecord $script:CurrentProjectName
  if (-not $project) {
    return
  }

  foreach ($import in @(Get-PropertyValue $project "imports" @())) {
    $script:Imports.Add([pscustomobject]@{
      File = Get-PropertyValue $import "File"
      Source = Get-PropertyValue $import "Source"
      Format = Get-PropertyValue $import "Format"
      Size = Get-PropertyValue $import "Size"
      Imported = Get-PropertyValue $import "Imported"
      Status = Get-PropertyValue $import "Status"
      Path = Get-PropertyValue $import "Path"
    })
  }
}

function Save-CurrentProjectImports {
  if (-not $script:IsAuthenticated -or [string]::IsNullOrWhiteSpace($script:CurrentProjectName)) {
    return
  }

  $project = Get-ProjectRecord $script:CurrentProjectName
  if (-not $project) {
    return
  }

  $project.imports = @($script:Imports)
  Save-ProjectStore
}

function Ensure-SignedIn {
  if ($script:IsAuthenticated) {
    return $true
  }

  [System.Windows.MessageBox]::Show($Window, "Sign in with a registered prototype account before opening project files.", "Sign in required", "OK", "Information") | Out-Null
  Set-Status "Sign in required before project files are visible"
  return $false
}

function Set-AuthenticatedControls {
  param([bool]$Enabled)

  foreach ($control in @(
    $ProjectNetworkCombo,
    $NewProjectButton,
    $TopImportButton,
    $ExportManifestButton,
    $ExportTemplateButton,
    $ChooseFilesButton,
    $ChooseFolderButton,
    $ClearImportsButton,
    $ExportFileHistoryButton
  )) {
    if ($control) {
      $control.IsEnabled = $Enabled
    }
  }
}

function Set-ProjectContext {
  param(
    [string]$ProjectName,
    [switch]$SyncSelectors
  )

  if ([string]::IsNullOrWhiteSpace($ProjectName)) {
    return
  }

  if (-not $script:IsAuthenticated) {
    $script:CurrentProjectName = $ProjectName
    if ($ProjectNameText) {
      $ProjectNameText.Text = $ProjectName
    }
    return
  }

  if ($script:CurrentProjectName -and $script:CurrentProjectName -ne $ProjectName) {
    Save-CurrentProjectImports
  }

  $project = Get-ProjectRecord $ProjectName
  if (-not $project) {
    [System.Windows.MessageBox]::Show($Window, "This project is not available to the signed-in prototype account.", "Project access denied", "OK", "Warning") | Out-Null
    return
  }

  $script:CurrentProjectName = $ProjectName
  if ($ProjectNameText) {
    $ProjectNameText.Text = $ProjectName
  }

  if ($SyncSelectors) {
    foreach ($combo in @($ProjectNetworkCombo, $SignInProjectCombo)) {
      if (-not $combo) { continue }
      for ($i = 0; $i -lt $combo.Items.Count; $i++) {
        if ([string]$combo.Items[$i].Content -eq $ProjectName) {
          $combo.SelectedIndex = $i
          break
        }
      }
    }
  }

  Load-ProjectImports
}

function Complete-SignIn {
  $name = if ($SignInNameBox) { $SignInNameBox.Text.Trim() } else { "" }
  $account = Find-PrototypeAccount $name
  if (-not $account) {
    [System.Windows.MessageBox]::Show($Window, "That prototype account is not registered. Entry denied.", "Access denied", "OK", "Error") | Out-Null
    Set-Status "Access denied for account name: $name"
    return
  }

  $displayName = Get-PropertyValue $account "displayName" $name
  $script:CurrentAccount = $account
  $script:CurrentUserName = $displayName
  $script:IsAuthenticated = $true
  if ($UserNameText) {
    $UserNameText.Text = $displayName
  }

  Set-AuthenticatedControls $true

  Refresh-ProjectSelectors
  $projects = Get-AuthorizedProjects
  if ($projects.Count -gt 0) {
    Set-ProjectContext (Get-PropertyValue $projects[0] "name") -SyncSelectors
  } else {
    $script:CurrentProjectName = ""
    $ProjectNameText.Text = "No project selected"
    $script:Imports.Clear()
  }

  if ($LoginOverlay) {
    $LoginOverlay.Visibility = "Collapsed"
  }
  Set-Status "Signed in as $displayName. Active project: $script:CurrentProjectName"
}

function Show-NewProjectPrompt {
  $promptXaml = @"
<Window
  xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  Title="New Project"
  Width="420"
  Height="230"
  ResizeMode="NoResize"
  WindowStartupLocation="CenterOwner"
  Background="#F7F9FC">
  <Border Background="#FFFFFF" BorderBrush="#DCE3EE" BorderThickness="1" CornerRadius="8" Padding="20" Margin="12">
    <StackPanel>
      <TextBlock Text="Name new project" Foreground="#132033" FontSize="20" FontWeight="SemiBold" />
      <TextBlock Text="Create an empty project connected to the signed-in prototype account." Foreground="#667287" TextWrapping="Wrap" Margin="0,8,0,14" />
      <TextBox x:Name="ProjectNameBox" Height="36" Margin="0,0,0,16" />
      <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
        <Button x:Name="CancelButton" Content="Cancel" Width="86" Height="34" Margin="0,0,8,0" />
        <Button x:Name="CreateButton" Content="Create" Width="86" Height="34" Background="#1559C9" Foreground="White" BorderBrush="#1559C9" />
      </StackPanel>
    </StackPanel>
  </Border>
</Window>
"@

  $reader = New-Object System.Xml.XmlNodeReader ([xml]$promptXaml)
  $prompt = [Windows.Markup.XamlReader]::Load($reader)
  $prompt.Owner = $Window
  $nameBox = $prompt.FindName("ProjectNameBox")
  $createButton = $prompt.FindName("CreateButton")
  $cancelButton = $prompt.FindName("CancelButton")
  $result = [pscustomobject]@{ Accepted = $false; Name = "" }

  $createButton.Add_Click({
    $result.Name = $nameBox.Text.Trim()
    if ([string]::IsNullOrWhiteSpace($result.Name)) {
      [System.Windows.MessageBox]::Show($prompt, "Enter a project name.", "Project name required", "OK", "Information") | Out-Null
      return
    }

    $result.Accepted = $true
    $prompt.DialogResult = $true
    $prompt.Close()
  })
  $cancelButton.Add_Click({
    $prompt.DialogResult = $false
    $prompt.Close()
  })
  $nameBox.Add_KeyDown({
    param($sender, $eventArgs)
    if ($eventArgs.Key -eq [Windows.Input.Key]::Enter) {
      $createButton.RaiseEvent((New-Object Windows.RoutedEventArgs([Windows.Controls.Button]::ClickEvent)))
    }
  })

  $prompt.Add_Loaded({ $nameBox.Focus() | Out-Null })
  $prompt.ShowDialog() | Out-Null
  return $result
}

function Create-NewProject {
  if (-not (Ensure-SignedIn)) {
    return
  }

  $prompt = Show-NewProjectPrompt
  if (-not $prompt.Accepted) {
    return
  }

  $name = $prompt.Name.Trim()
  $owner = Get-CurrentOwnerName
  foreach ($project in (Get-AuthorizedProjects)) {
    if ((Get-PropertyValue $project "name") -eq $name) {
      [System.Windows.MessageBox]::Show($Window, "A project with that name already exists for this account.", "Duplicate project", "OK", "Warning") | Out-Null
      return
    }
  }

  Save-CurrentProjectImports
  $script:ProjectStore += (New-ProjectRecord $name $owner)
  Save-ProjectStore
  Refresh-ProjectSelectors $name
  Set-ProjectContext $name -SyncSelectors
  Set-Status "Created new empty project: $name"
}

function Format-Bytes {
  param([long]$Bytes)

  if ($Bytes -lt 1KB) { return "$Bytes B" }
  if ($Bytes -lt 1MB) { return "{0:N1} KB" -f ($Bytes / 1KB) }
  if ($Bytes -lt 1GB) { return "{0:N1} MB" -f ($Bytes / 1MB) }
  return "{0:N1} GB" -f ($Bytes / 1GB)
}

function Get-SelectedSourceType {
  $item = $SourceTypeCombo.SelectedItem
  if ($item -and $item.Content) {
    return [string]$item.Content
  }
  return "Unknown"
}

function Get-SourceFormat {
  param([System.IO.FileSystemInfo]$Item)

  if ($Item.PSIsContainer) {
    if ($Item.Name.ToLowerInvariant().EndsWith(".gdb")) { return "File Geodatabase" }
    return "Folder"
  }

  $extension = $Item.Extension.TrimStart(".").ToLowerInvariant()
  switch ($extension) {
    "csv" { "CSV" }
    "xlsx" { "Excel" }
    "xls" { "Excel" }
    "json" { "JSON" }
    "geojson" { "GeoJSON" }
    "shp" { "Esri Shapefile" }
    "gpkg" { "GeoPackage" }
    "kml" { "KML" }
    "kmz" { "KMZ" }
    "tab" { "MapInfo TAB" }
    "mif" { "MapInfo MIF" }
    "mid" { "MapInfo MID" }
    "dxf" { "DXF" }
    "dwg" { "DWG" }
    "dxl" { "DXL" }
    "dss" { "OpenDSS" }
    "glm" { "GridLAB-D" }
    "xml" { "XML / CIM" }
    "rdf" { "CIM RDF" }
    "raw" { "PSS/E RAW" }
    "olr" { "ASPEN OneLiner" }
    "cfg" { "COMTRADE CFG" }
    "dat" { "COMTRADE DAT" }
    "zip" { "Archive" }
    default {
      if ($extension) { $extension.ToUpperInvariant() } else { "Unknown" }
    }
  }
}

function Add-ImportPath {
  param([string]$Path)

  if (-not (Ensure-SignedIn)) {
    return
  }

  if ([string]::IsNullOrWhiteSpace($script:CurrentProjectName)) {
    [System.Windows.MessageBox]::Show($Window, "Create or select a project before staging imports.", "No project selected", "OK", "Information") | Out-Null
    return
  }

  if (-not (Test-Path -LiteralPath $Path)) {
    return
  }

  $item = Get-Item -LiteralPath $Path
  $length = if ($item.PSIsContainer) { 0 } else { $item.Length }
  $import = [pscustomobject]@{
    File = $item.Name
    Source = Get-SelectedSourceType
    Format = Get-SourceFormat $item
    Size = if ($item.PSIsContainer) { "Folder" } else { Format-Bytes $length }
    Imported = (Get-Date).ToString("yyyy-MM-dd HH:mm")
    Status = "Staged"
    Path = $item.FullName
  }
  $script:Imports.Insert(0, $import)
  Save-CurrentProjectImports
}

function Choose-ImportFiles {
  if (-not (Ensure-SignedIn)) {
    return
  }

  $dialog = New-Object System.Windows.Forms.OpenFileDialog
  $dialog.Multiselect = $true
  $dialog.Title = "Import source files"
  $dialog.Filter = "Supported source files|*.csv;*.xlsx;*.xls;*.json;*.geojson;*.shp;*.dbf;*.prj;*.shx;*.zip;*.gpkg;*.kml;*.kmz;*.tab;*.mif;*.mid;*.dxf;*.dwg;*.dxl;*.dss;*.glm;*.xml;*.rdf;*.raw;*.olr;*.cfg;*.dat;*.txt;*.m;*.mat;*.mdb;*.accdb|All files|*.*"
  if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    foreach ($fileName in $dialog.FileNames) {
      Add-ImportPath $fileName
    }
    Set-Status "$($dialog.FileNames.Count) import file(s) staged"
  }
}

function Choose-ImportFolder {
  if (-not (Ensure-SignedIn)) {
    return
  }

  $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
  $dialog.Description = "Select a File Geodatabase, GIS export folder, model folder or platform project folder"
  if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    Add-ImportPath $dialog.SelectedPath
    Set-Status "Import folder staged"
  }
}

function Get-ImportManifest {
  $map = [pscustomobject]@{
    centerLat = $script:MapState.CenterLat
    centerLng = $script:MapState.CenterLng
    zoom = $script:MapState.Zoom
    layer = $script:MapState.Layer
  }

  return [pscustomobject]@{
    project = "Recloser Optimisation"
    activeProject = $script:CurrentProjectName
    signedInUser = $script:CurrentUserName
    generatedAt = (Get-Date).ToUniversalTime().ToString("o")
    scope = [pscustomobject]@{
      Storage = "metadata staging only"
      processing = "not implemented"
      validation = "not implemented"
      optimisation = "not implemented"
      map = "live online tile basemap with empty future feeder overlay"
    }
    imports = @($script:Imports)
    adapters = @($script:Adapters)
    model = [pscustomobject]@{
      nodes = @()
      lineSegments = @()
      protectionDevices = @()
      customerGroups = @()
      outageEvents = @()
      validationIssues = @()
    }
    map = $map
  }
}

function Save-TextFile {
  param(
    [string]$Title,
    [string]$DefaultFileName,
    [string]$Filter,
    [string]$Content
  )

  $dialog = New-Object System.Windows.Forms.SaveFileDialog
  $dialog.Title = $Title
  $dialog.FileName = $DefaultFileName
  $dialog.Filter = $Filter
  if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    [System.IO.File]::WriteAllText($dialog.FileName, $Content, [System.Text.Encoding]::UTF8)
    Set-Status "Exported $([System.IO.Path]::GetFileName($dialog.FileName))"
  }
}

function Export-Manifest {
  if (-not (Ensure-SignedIn)) {
    return
  }

  $json = Get-ImportManifest | ConvertTo-Json -Depth 8
  Save-TextFile "Export project state" "recloser-optimisation-manifest.json" "JSON files|*.json|All files|*.*" $json
}

function Export-Template {
  $csv = @(
    "source_group,platform,file_name,asset_id,parent_id,asset_type,feeder_id,latitude,longitude,voltage_kv,customers,notes",
    "GIS / mapping,Esri ArcGIS,,,,line_section,,,,,,",
    "Electrical model,OpenDSS,,,,node,,,,,,",
    "Protection settings,SEL / protection export,,,,recloser,,,,,,",
    "OMS / outage history,OMS,,,,outage_event,,,,,,"
  ) -join [Environment]::NewLine
  Save-TextFile "Export import template" "recloser-import-template.csv" "CSV files|*.csv|All files|*.*" $csv
}

function Export-GeoJson {
  $geoJson = [pscustomobject]@{
    type = "FeatureCollection"
    name = "empty-feeder-overlay"
    features = @()
  } | ConvertTo-Json -Depth 6
  Save-TextFile "Export empty feeder overlay" "empty-feeder-overlay.geojson" "GeoJSON files|*.geojson|JSON files|*.json|All files|*.*" $geoJson
}

function Get-MapScale {
  param([int]$Zoom)
  return $script:MapState.TileSize * [math]::Pow(2, $Zoom)
}

function Get-WorldPixelX {
  param([double]$Lon, [int]$Zoom)
  return (($Lon + 180.0) / 360.0) * (Get-MapScale $Zoom)
}

function Get-WorldPixelY {
  param([double]$Lat, [int]$Zoom)
  $siny = [math]::Sin($Lat * [math]::PI / 180.0)
  $siny = [math]::Min([math]::Max($siny, -0.9999), 0.9999)
  return (0.5 - ([math]::Log((1 + $siny) / (1 - $siny)) / (4 * [math]::PI))) * (Get-MapScale $Zoom)
}

function Get-LonFromWorldPixel {
  param([double]$X, [int]$Zoom)
  return ($X / (Get-MapScale $Zoom)) * 360.0 - 180.0
}

function Get-LatFromWorldPixel {
  param([double]$Y, [int]$Zoom)
  $n = [math]::PI - (2.0 * [math]::PI * $Y / (Get-MapScale $Zoom))
  return [math]::Atan([math]::Sinh($n)) * 180.0 / [math]::PI
}

function Get-TileUrl {
  param([string]$Layer, [int]$X, [int]$Y, [int]$Zoom)

  $subdomains = @("a","b","c")
  $sub = $subdomains[($X + $Y) % $subdomains.Count]
  switch ($Layer) {
    "Satellite" { return "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/$Zoom/$Y/$X" }
    "Terrain" { return "https://$sub.tile.opentopomap.org/$Zoom/$X/$Y.png" }
    "Altitude" { return "https://server.arcgisonline.com/ArcGIS/rest/services/Elevation/World_Hillshade/MapServer/tile/$Zoom/$Y/$X" }
    default { return "https://$sub.tile.openstreetmap.org/$Zoom/$X/$Y.png" }
  }
}

function Update-MapReadout {
  $MapReadout.Text = "Lat {0:N4}, Lng {1:N4}, Zoom {2}" -f $script:MapState.CenterLat, $script:MapState.CenterLng, $script:MapState.Zoom
}

function Render-Map {
  if (-not $TileCanvas -or -not $MapHost) { return }
  if ($MapHost.ActualWidth -lt 10 -or $MapHost.ActualHeight -lt 10) { return }

  $TileCanvas.Children.Clear()
  $zoom = [int]$script:MapState.Zoom
  $tileSize = [double]$script:MapState.TileSize
  $tileCount = [int][math]::Pow(2, $zoom)
  $centerX = Get-WorldPixelX $script:MapState.CenterLng $zoom
  $centerY = Get-WorldPixelY $script:MapState.CenterLat $zoom
  $left = $centerX - ($MapHost.ActualWidth / 2.0)
  $top = $centerY - ($MapHost.ActualHeight / 2.0)
  $startTileX = [int][math]::Floor($left / $tileSize)
  $endTileX = [int][math]::Floor(($left + $MapHost.ActualWidth) / $tileSize)
  $startTileY = [int][math]::Floor($top / $tileSize)
  $endTileY = [int][math]::Floor(($top + $MapHost.ActualHeight) / $tileSize)

  for ($tx = $startTileX; $tx -le $endTileX; $tx++) {
    for ($ty = $startTileY; $ty -le $endTileY; $ty++) {
      if ($ty -lt 0 -or $ty -ge $tileCount) { continue }
      $wrappedX = [int](($tx % $tileCount + $tileCount) % $tileCount)
      $url = Get-TileUrl $script:MapState.Layer $wrappedX $ty $zoom
      $image = New-Object Windows.Controls.Image
      $image.Width = $tileSize
      $image.Height = $tileSize
      $image.Stretch = [Windows.Media.Stretch]::Fill
      try {
        $bitmap = New-Object Windows.Media.Imaging.BitmapImage
        $bitmap.BeginInit()
        $bitmap.UriSource = [Uri]$url
        $bitmap.CacheOption = [Windows.Media.Imaging.BitmapCacheOption]::OnLoad
        $bitmap.CreateOptions = [Windows.Media.Imaging.BitmapCreateOptions]::IgnoreImageCache
        $bitmap.EndInit()
        $image.Source = $bitmap
      } catch {
        $image.ToolTip = "Tile unavailable: $url"
      }
      [Windows.Controls.Canvas]::SetLeft($image, ($tx * $tileSize) - $left)
      [Windows.Controls.Canvas]::SetTop($image, ($ty * $tileSize) - $top)
      $TileCanvas.Children.Add($image) | Out-Null
    }
  }

  Update-MapReadout
}

function Center-Map {
  $script:MapState.CenterLat = -38.335
  $script:MapState.CenterLng = 175.165
  $script:MapState.Zoom = 10
  Render-Map
  Set-Status "Map centered on The Lines Company network area"
}

foreach ($button in $script:NavButtons) {
  $button.Add_Click({
    param($sender, $eventArgs)
    Show-Page ([string]$sender.Tag)
  })
}

function Render-Radar {
    if (-not $RadarCanvas -or -not $RadarHost) { return }
    if ($RadarHost.ActualWidth -lt 10 -or $RadarHost.ActualHeight -lt 10) { return }
    $RadarCanvas.Children.Clear()

    $values = @(0.82, 0.76, 0.88, 0.69, 0.73, 0.80)
    $labels = @("Connectivity","Completeness","Spatial","Feasibility","Size","Verify")
    $centerX = $RadarCanvas.ActualWidth / 2.0
    $centerY = $RadarCanvas.ActualHeight / 2.0
    $radius = [math]::Min($centerX, $centerY) * 0.7
    $count = $values.Length
    $points = @()

    for ($i = 0; $i -lt $count; $i++) {
      $angle = (2 * [math]::PI * $i / $count) - ([math]::PI / 2)
      $value = $values[$i]
      $r = $radius * $value
      $x = $centerX + ($r * [math]::Cos($angle))
      $y = $centerY + ($r * [math]::Sin($angle))
      $points += "$x,$y"
      # Axis line
      $axisX = $centerX + ($radius * [math]::Cos($angle))
      $axisY = $centerY + ($radius * [math]::Sin($angle))
      $line = New-Object Windows.Shapes.Line
      $line.X1 = $centerX
      $line.Y1 = $centerY
      $line.X2 = $axisX
      $line.Y2 = $axisY
      $line.Stroke = "Gray"
      $line.StrokeThickness = 1
      $RadarCanvas.Children.Add($line) | Out-Null
      # Label
      $text = New-Object Windows.Controls.TextBlock
      $text.Text = $labels[$i]
      [Windows.Controls.Canvas]::SetLeft($text, $axisX)
      [Windows.Controls.Canvas]::SetTop($text, $axisY)
      $RadarCanvas.Children.Add($text) | Out-Null
    }
    # Radar polygon
    $polygon = New-Object Windows.Shapes.Polygon
    $polygon.Points = [Windows.Media.PointCollection]::Parse(($points -join " "))
    $polygon.Fill = "#883399FF"
    $polygon.Stroke = "#FF0066CC"
    $polygon.StrokeThickness = 2
    $RadarCanvas.Children.Add($polygon) | Out-Null
  }

  function Update-RadarReadout {
    $values = @(0.82, 0.76, 0.88, 0.69, 0.73, 0.80)
    $RadarReadout.Text = "Connectivity: $($values[0]), Completeness: $($values[1]), Spatial: $($values[2]),
    Feasibility: $($values[3]), Size: $($values[4]), Verification: $($values[5])" -f $script:MapState.CenterLat, $script:MapState.CenterLng, $script:MapState.Zoom
  }


(Get-Control "TopImportButton").Add_Click({ Show-Page "Storage"; Choose-ImportFiles })
(Get-Control "ChooseFilesButton").Add_Click({ Choose-ImportFiles })
(Get-Control "ChooseFolderButton").Add_Click({ Choose-ImportFolder })
(Get-Control "ClearImportsButton").Add_Click({
  if (-not (Ensure-SignedIn)) {
    return
  }
  $script:Imports.Clear()
  Save-CurrentProjectImports
  Set-Status "File History cleared"
})
(Get-Control "ExportManifestButton").Add_Click({ Export-Manifest })
(Get-Control "ExportFileHistoryButton").Add_Click({ Export-Manifest })
(Get-Control "ExportTemplateButton").Add_Click({ Export-Template })
(Get-Control "ExportGeoJsonButton").Add_Click({ Export-GeoJson })
(Get-Control "CenterMapButton").Add_Click({ Center-Map })
if ($SignInButton) {
  $SignInButton.Add_Click({ Complete-SignIn })
}
if ($SignInNameBox) {
  $SignInNameBox.Add_KeyDown({
    param($sender, $eventArgs)
    if ($eventArgs.Key -eq [Windows.Input.Key]::Enter) {
      Complete-SignIn
    }
  })
}
if ($ProjectNetworkCombo) {
  $ProjectNetworkCombo.Add_SelectionChanged({
    if ($script:IsRefreshingProjects) {
      return
    }
    if (-not (Ensure-SignedIn)) {
      return
    }
    $project = Get-ComboText $ProjectNetworkCombo
    Set-ProjectContext $project
    Set-Status "Switched active project to $script:CurrentProjectName"
  })
}
if ($NewProjectButton) {
  $NewProjectButton.Add_Click({ Create-NewProject })
}
if ($SignInProjectCombo) {
  $SignInProjectCombo.Add_SelectionChanged({
    $project = Get-ComboText $SignInProjectCombo
    Set-ProjectContext $project
  })
}

$MapLayerCombo.Add_SelectionChanged({
  if ($MapLayerCombo.SelectedItem -and $MapLayerCombo.SelectedItem.Content) {
    $script:MapState.Layer = [string]$MapLayerCombo.SelectedItem.Content
    Render-Map
    Set-Status "$($script:MapState.Layer) basemap selected"
  }
})

$OverlayToggle.Add_Checked({ $MapEmptyBadge.Visibility = "Visible" })
$OverlayToggle.Add_Unchecked({ $MapEmptyBadge.Visibility = "Collapsed" })
$MapHost.Add_SizeChanged({ Render-Map })
$MapHost.Add_MouseWheel({
  param($sender, $eventArgs)
  if ($eventArgs.Delta -gt 0) {
    $script:MapState.Zoom = [math]::Min(18, $script:MapState.Zoom + 1)
  } else {
    $script:MapState.Zoom = [math]::Max(3, $script:MapState.Zoom - 1)
  }
  Render-Map
  $eventArgs.Handled = $true
})
$MapHost.Add_MouseLeftButtonDown({
  param($sender, $eventArgs)
  $script:MapState.Dragging = $true
  $script:MapState.LastPoint = $eventArgs.GetPosition($MapHost)
  $MapHost.CaptureMouse() | Out-Null
})
$MapHost.Add_MouseLeftButtonUp({
  $script:MapState.Dragging = $false
  $script:MapState.LastPoint = $null
  $MapHost.ReleaseMouseCapture()
})
$MapHost.Add_MouseLeave({
  if ($script:MapState.Dragging) {
    $script:MapState.Dragging = $false
    $script:MapState.LastPoint = $null
    $MapHost.ReleaseMouseCapture()
  }
})
$MapHost.Add_MouseMove({
  param($sender, $eventArgs)
  if (-not $script:MapState.Dragging -or -not $script:MapState.LastPoint) { return }
  $point = $eventArgs.GetPosition($MapHost)
  $dx = $point.X - $script:MapState.LastPoint.X
  $dy = $point.Y - $script:MapState.LastPoint.Y
  $zoom = [int]$script:MapState.Zoom
  $scale = Get-MapScale $zoom
  $centerX = (Get-WorldPixelX $script:MapState.CenterLng $zoom) - $dx
  $centerY = (Get-WorldPixelY $script:MapState.CenterLat $zoom) - $dy
  $centerY = [math]::Min([math]::Max($centerY, 0), $scale)
  $script:MapState.CenterLng = Get-LonFromWorldPixel $centerX $zoom
  $script:MapState.CenterLat = [math]::Min([math]::Max((Get-LatFromWorldPixel $centerY $zoom), -85.0511), 85.0511)
  $script:MapState.LastPoint = $point
  Render-Map
})



Load-Adapters
Load-Reports
Load-Branding
Load-PrototypeAccounts
Load-ProjectStore
Show-Page "Dashboard"
Set-Status "Ready. Sign in to start a local prototype session."
$Window.ShowDialog() | Out-Null
