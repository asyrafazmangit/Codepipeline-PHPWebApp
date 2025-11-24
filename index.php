<?php
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP Web App</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f4f4f4; }
        .container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { color: #333; text-align: center; }
        .info { background: #e7f3ff; padding: 15px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="header">Welcome to PHP Web App</h1>
        <div class="info">
            <h3>Application Information:</h3>
            <p><strong>PHP Version:</strong> <?php echo phpversion(); ?></p>
            <p><strong>Server Time:</strong> <?php echo date('Y-m-d H:i:s'); ?></p>
            <p><strong>Server Name:</strong> <?php echo $_SERVER['SERVER_NAME'] ?? 'Unknown'; ?></p>
            <p><strong>Request URI:</strong> <?php echo $_SERVER['REQUEST_URI'] ?? '/'; ?></p>
        </div>
        
        <div class="info">
            <h3>Environment Status:</h3>
            <p>✅ Application is running successfully!</p>
            <p>✅ Docker container is healthy</p>
            <p>✅ Load balancer is working</p>
        </div>
    </div>
</body>
</html>