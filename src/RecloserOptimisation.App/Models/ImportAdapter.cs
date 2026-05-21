using System.Text.Json.Serialization;

namespace RecloserOptimisation.App.Models;

public sealed class ImportAdapter
{
    [JsonPropertyName("category")]
    public string Category { get; set; } = "";

    [JsonPropertyName("platform")]
    public string Platform { get; set; } = "";

    [JsonPropertyName("formats")]
    public string Formats { get; set; } = "";

    [JsonPropertyName("status")]
    public string Status { get; set; } = "";

    [JsonPropertyName("purpose")]
    public string Purpose { get; set; } = "";
}
