@echo off
rem Şarkışla Yoklama - web sürümünü açar (demo modu).
rem Kullanım: bu dosyaya çift tıklayın. Kapatmak için siyah pencereyi kapatın.
rem Aynı Wi-Fi ağındaki telefonlar da (iPhone dahil) açabilir.
chcp 65001 >nul
cd /d "%~dp0build\web"
if not exist index.html (
  echo Web derlemesi bulunamadi. Once proje klasorunde su komutu calistirin:
  echo     flutter build web --release
  pause
  exit /b 1
)
echo.
echo  Sarkisla Yoklama calisiyor.
echo.
echo  Bu bilgisayarda:   http://localhost:8080
echo  Telefonda (ayni Wi-Fi), asagidaki IPv4 adreslerinden birine
echo  ":8080" ekleyerek Safari/Chrome'a yazin. Ornek: http://192.168.1.102:8080
echo.
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do for /f "tokens=*" %%b in ("%%a") do echo     http://%%b:8080
echo.
echo  Bu pencere acik kaldigi surece uygulama calisir.
echo.
start "" http://localhost:8080
py -3 -m http.server 8080 --bind 0.0.0.0
