using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace FSP.CarbonAwarePoC.API
{
    public class DoWorkFunction
    {
        private readonly ILogger _logger;

        public DoWorkFunction(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<DoWorkFunction>();
        }

        [Function("DoWork")]
        public HttpResponseData Run([HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequestData req)
        {
            var region = Environment.GetEnvironmentVariable("REGION_NAME");

            var response = req.CreateResponse(HttpStatusCode.OK);
            
            var data = new
            {
                region = region
            };

            response.WriteAsJsonAsync(data);

            return response;
        }
    }
}
