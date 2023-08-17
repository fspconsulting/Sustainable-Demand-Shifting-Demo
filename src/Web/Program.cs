var builder = WebApplication.CreateBuilder(args);

// Access User Secrets 
var userSecretsConfig = new ConfigurationBuilder()
    .AddUserSecrets<Program>()
    .Build();

// Bind User Secrets
var connectionStringOptions = new ConnectionStringOptions();
userSecretsConfig.GetSection(ConnectionStringOptions.SectionName).Bind(connectionStringOptions);
builder.Services.AddSingleton(connectionStringOptions);

// Add services to the container.
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();

builder.Services.AddHttpClient<IWorkService, WorkService>(client =>
{
    client.BaseAddress = new Uri(connectionStringOptions.apim);
});

builder.Services.AddHttpClient<IEmissionsService, EmissionsService>(client =>
{
    client.BaseAddress = new Uri(connectionStringOptions.capp);
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();

app.UseRouting();

app.MapBlazorHub();
app.MapFallbackToPage("/_Host");

app.Run();