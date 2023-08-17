public interface IWorkService
{
    Task<WorkData?> DoWorkAsync(string location);
}