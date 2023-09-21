using Microsoft.AspNetCore.Localization;
using System.Globalization;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
SetupLocalization(app, "th-TH");
app.UseAuthorization();
app.MapControllers();

app.Run();

static void SetupLocalization(IApplicationBuilder app, string cultureName = "th-TH")
{
    var supportedCultures = new[]          {
                new CultureInfo(cultureName)
            };
    app.UseRequestLocalization(new RequestLocalizationOptions
    {
        DefaultRequestCulture = new RequestCulture(cultureName),
        // Formatting numbers, dates, etc.
        SupportedCultures = supportedCultures,
        // UI strings that we have localized.
        SupportedUICultures = supportedCultures
    });
}