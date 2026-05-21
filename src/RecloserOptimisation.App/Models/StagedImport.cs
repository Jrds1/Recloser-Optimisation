namespace RecloserOptimisation.App.Models;

public sealed class StagedImport
{
    public string File { get; set; } = "";
    public string Source { get; set; } = "";
    public string Format { get; set; } = "";
    public string Size { get; set; } = "";
    public string Imported { get; set; } = "";
    public string Status { get; set; } = "";
    public string Path { get; set; } = "";
}
