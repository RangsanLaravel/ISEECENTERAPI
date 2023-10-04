using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Localization;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Globalization;
using System.Text;

var builder = WebApplication.CreateBuilder(args);


// Add services to the container.

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidIssuer = builder.Configuration["Jwt:Issuer"],

        ValidateAudience = true,
        ValidAudience = builder.Configuration["Jwt:Audience"],

        ValidateLifetime = true,
        ClockSkew = TimeSpan.Zero, // disable delay when token is expire

        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]))
    };
});

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddCors(options =>
{    
    options.AddPolicy("AllowSpecificOrigins",
     builder =>
     {
         builder.WithOrigins(
             "http://example.com",
             "http://localhost:4200")
             .AllowAnyHeader()
             .AllowAnyMethod();
         //.WithMethods("GET", "POST", "HEAD");
     });  
    options.AddPolicy("AllowAll",
     builder =>
     {
         builder.AllowAnyOrigin()
         .AllowAnyHeader()
         .AllowAnyMethod();
     });

    /*
        The browser can skip the preflight request
        if the following conditions are true:
        - The request method is GET, HEAD, or POST.
        - The Content-Type header
           - application/x-www-form-urlencoded
           - multipart/form-data
           - text/plain
    */
});
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "ISEEServiceAPI", Version = "v1" });

    var securitySchema = new OpenApiSecurityScheme
    {
        Description = "JWT Authorization header using the Bearer scheme. Example: \"Authorization: Bearer {token}\"",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        Reference = new OpenApiReference
        {
            Type = ReferenceType.SecurityScheme,
            Id = "Bearer"
        }
    };

    c.AddSecurityDefinition("Bearer", securitySchema);

    var securityRequirement = new OpenApiSecurityRequirement
                {
                    { securitySchema, new[] { "Bearer" } }
                };

    c.AddSecurityRequirement(securityRequirement);
});

var app = builder.Build();

// Configure the HTTP request pipeline.

app.UseSwagger();
app.UseSwaggerUI();
SetupLocalization(app, "th-TH");
app.UseCors("AllowAll");
//jwt 
app.UseAuthentication();
//Authen claim
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