public interface IEmissionsService
{
    Task<EmissionsData[]> GetEmissionsDataAsync();
}