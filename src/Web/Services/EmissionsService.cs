public class EmissionsService : IEmissionsService
{
    private HttpClient HttpClient { get; set; }

    public EmissionsService(HttpClient httpClient) => HttpClient = httpClient ?? throw new ArgumentNullException(nameof(httpClient));

    public async Task<EmissionsData[]> GetEmissionsDataAsync()
    {
        var emissionsData = await HttpClient.GetFromJsonAsync<EmissionsData[]>("/emissions/bylocations?location=IE&location=GB");
        return emissionsData;
    }
}
