using WebApiPolizas.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.AspNetCore.Http; // 👈 asegúrate que esté este using también

var builder = WebApplication.CreateBuilder(args);

// Agregar soporte para AWS Lambda hosting
builder.Services.AddAWSLambdaHosting(LambdaEventSource.RestApi);

// Servicios
builder.Services.AddControllers()
    .AddNewtonsoftJson(options =>
    {
        options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;
    });

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<PolizasDBContext>(options =>
{
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("ConnectSQL"),
        sqlOptions => sqlOptions.EnableRetryOnFailure(
            maxRetryCount: 5,
            maxRetryDelay: TimeSpan.FromSeconds(10),
            errorNumbersToAdd: null
        )
    );
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("NuevaPolitica", app =>
    {
        app.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
    });
});

builder.Services.AddAuthentication("Bearer")
    .AddJwtBearer("Bearer", options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = "tu-app",
            ValidAudience = "tu-app",
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("Nsd258FP"))
        };
    });

builder.Services.AddAuthorization();

// Construir app
var app = builder.Build();

// 🚨 Captura global de excepciones (middleware personalizado)
app.Use(async (context, next) =>
{
    try
    {
        await next();
    }
    catch (Exception ex)
    {
        context.Response.StatusCode = 500;
        context.Response.ContentType = "application/json";

        var error = new
        {
            message = ex.Message,
            stackTrace = ex.StackTrace,
            innerException = ex.InnerException?.Message
        };

        await context.Response.WriteAsJsonAsync(error);
    }
});

// Middlewares
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("NuevaPolitica");
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
app.MapGet("/", () => "API Running!");

app.Run();
