using System.Diagnostics;

public class WorkService : IWorkService
{
    private HttpClient HttpClient { get; set; }

    public WorkService(HttpClient httpClient) => HttpClient = httpClient ?? throw new ArgumentNullException(nameof(httpClient));

    public async Task<WorkData?> DoWorkAsync(string location)
    {
        var request = new HttpRequestMessage(HttpMethod.Get, "/sds-demo/v1.0/dowork");

        if (!string.Equals(location, Constants.ECO))
        {
            request.Headers.Add("x-fsp-location", location);
        }

        Stopwatch stopWatch = new Stopwatch();
        stopWatch.Start();

        var response = await HttpClient.SendAsync(request);
        response.EnsureSuccessStatusCode();

        var workData = await response.Content.ReadFromJsonAsync<WorkData?>();

        stopWatch.Stop();
        workData.Duration = stopWatch.Elapsed;
        
        return workData;
    }
}
