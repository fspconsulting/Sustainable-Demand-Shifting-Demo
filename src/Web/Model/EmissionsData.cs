public class EmissionsData
{
    public string Location { get; set; }
    public DateTimeOffset Time { get; set; }
    public double Rating { get; set; }    
    public TimeSpan Duration { get; set; }

    public string RatingFomatted 
    { 
        get => Rating.ToString("0 gCO₂eq/kWh");
    }
}