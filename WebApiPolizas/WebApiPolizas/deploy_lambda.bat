@echo off
echo -------------------------------
echo Publicando WebApiPolizas...
echo -------------------------------
dotnet publish -c Release -o publish

if %errorlevel% neq 0 (
    echo Error en el publish. Abortando.
    exit /b %errorlevel%
)

echo -------------------------------
echo Creando ZIP para Lambda...
echo -------------------------------
cd publish
powershell -Command "Compress-Archive * ../WebApiPolizas.zip -Force"
cd ..

echo -------------------------------
echo Listo! ZIP generado: WebApiPolizas.zip
echo Ahora puedes subirlo manualmente en AWS Lambda.
pause
