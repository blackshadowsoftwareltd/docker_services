document.addEventListener('DOMContentLoaded', function() {
    console.log('👨‍💻 Portfolio loaded successfully!');
    
    const portfolio = document.getElementById('portfolio');
    if (portfolio) {
        portfolio.innerHTML = `
            <h2>Welcome to my Professional Portfolio! 👨‍💻</h2>
            <p>I'm a passionate developer focused on creating efficient, scalable, and maintainable solutions.</p>
            
            <div style="text-align: center; margin: 30px 0;">
                <span class="status-badge">🚀 Available for Projects</span>
            </div>
            
            <div style="margin-top: 40px;">
                <h3>🛠️ Skills & Technologies</h3>
                <ul class="skills-list">
                    <li>🦀 <strong>Rust Development</strong><br>Backend APIs, web servers, system programming</li>
                    <li>🌐 <strong>Web Technologies</strong><br>HTML5, CSS3, JavaScript (ES6+)</li>
                    <li>🐳 <strong>DevOps & Containerization</strong><br>Docker, Docker Compose, CI/CD</li>
                    <li>⚡ <strong>Server Management</strong><br>Nginx, reverse proxies, load balancing</li>
                    <li>🗄️ <strong>Databases</strong><br>PostgreSQL, Redis, MongoDB</li>
                </ul>
            </div>
            
            <div style="margin-top: 40px;">
                <h3>🚀 Current Projects</h3>
                <div style="margin: 20px 0; padding: 20px; background: rgba(255,255,255,0.1); border-radius: 10px;">
                    <h4>⛽ Fuel Cost Dashboard</h4>
                    <p>A comprehensive fuel expense tracking application built with Rust backend and modern web frontend.</p>
                    <p><strong>Tech Stack:</strong> Rust, Docker, Nginx, PostgreSQL</p>
                </div>
            </div>
        `;
    }
});
