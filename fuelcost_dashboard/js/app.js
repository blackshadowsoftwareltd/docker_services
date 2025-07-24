document.addEventListener('DOMContentLoaded', function() {
    console.log('🚗 Fuel Dashboard loaded successfully!');
    
    const app = document.getElementById('app');
    if (app) {
        app.innerHTML = `
            <div class="card">
                <h2>Welcome to your Fuel Cost Dashboard! 🚗⛽</h2>
                <p>Track your fuel expenses, analyze trends, and optimize your vehicle costs.</p>
                <span class="status-badge">✅ System Online</span>
            </div>
            
            <div class="card">
                <h3>📊 Dashboard Features</h3>
                <ul>
                    <li>Track monthly fuel expenses</li>
                    <li>Analyze cost trends over time</li>
                    <li>Monitor fuel efficiency</li>
                    <li>Set budget alerts</li>
                </ul>
            </div>
            
            <div class="card">
                <h3>🚀 Ready to connect your backend?</h3>
                <p>This dashboard is ready to connect to your Rust fuel_server API.</p>
                <p>API endpoint will be: <code>/api/</code> (when backend is deployed)</p>
            </div>
        `;
    }
});
