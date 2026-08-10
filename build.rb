require 'yaml'
require 'erb'

# 1. Carrega os dados do YAML
dados = YAML.load_file('dados.yml') rescue {}
dados['nome'] ||= "Seu Nome"
dados['titulo'] ||= "Estudante de ADS & Segurança"
dados['descricao'] ||= "Focado em Desenvolvimento e Segurança da Informação."
dados['sobre'] ||= "Olá!"
dados['habilidades'] ||= []
dados['projetos'] ||= []

# 2. Template HTML
template_html = <<~HTML
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The Code Architect | <%= dados['nome'] %></title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background-color: #06090f; color: #e6edf3; line-height: 1.6; padding-top: 80px; }
        a { text-decoration: none; color: inherit; transition: 0.3s; }
        header { background: rgba(13, 17, 23, 0.9); padding: 1rem 2rem; position: fixed; width: 100%; top: 0; border-bottom: 1px solid #30363d; backdrop-filter: blur(10px); display: flex; justify-content: space-between; align-items: center; z-index: 1000; }
        .logo { font-size: 1.2rem; font-weight: bold; color: #00ff66; font-family: monospace; }
        .logo::before { content: "{ "; }
        .logo::after { content: " } Code.Architect"; }
        nav a { color: #8b949e; margin-left: 1.5rem; }
        nav a:hover, nav a.active { color: #00ff66; }
        .hero { text-align: center; padding: 4rem 2rem; background: radial-gradient(circle at center, #161b22 0%, #06090f 100%); }
        .hero h1 { font-size: 2.5rem; margin-bottom: 1rem; color: #ffffff; }
        .hero p { color: #8b949e; max-width: 600px; margin: 0 auto 2rem; }
        .btn { display: inline-block; background: #00ff66; color: #06090f; padding: 0.8rem 1.5rem; border-radius: 6px; font-weight: bold; cursor: pointer; border: none; }
        .btn:hover { background: #00cc52; }
        .container { max-width: 1000px; margin: 0 auto; padding: 2rem; }
        .section { margin-bottom: 4rem; }
        .section-title { font-size: 1.5rem; color: #00ff66; margin-bottom: 1.5rem; border-bottom: 1px solid #30363d; padding-bottom: 0.5rem; }
        .card-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem; }
        .card { background: #0d1117; border: 1px solid #30363d; padding: 1.5rem; border-radius: 8px; }
        .card h3 { color: #58a6ff; margin-bottom: 0.5rem; }
        textarea { width: 100%; height: 180px; background: #0d1117; color: #00ff66; border: 1px solid #30363d; padding: 1rem; font-family: monospace; border-radius: 6px; margin-bottom: 1rem; resize: vertical; }
        #output { background: #010409; border: 1px solid #30363d; padding: 1rem; border-radius: 6px; color: #7ee787; font-family: monospace; white-space: pre-wrap; display: none; margin-top: 1rem; }
        footer { text-align: center; padding: 2rem; color: #8b949e; border-top: 1px solid #30363d; font-size: 0.9rem; }
    </style>
</head>
<body>

    <header>
        <div class="logo">PAGE</div>
        <nav>
            <a href="#about">Sobre</a>
            <a href="#skills">Habilidades</a>
            <a href="#projects">Projetos</a>
            <a href="#code-architect">Architect</a>
        </nav>
    </header>

    <section class="hero">
        <h1>Diagramação Lógica & Mapeamento Visual de Código</h1>
        <p>Transforme códigos complexos em mapas interativos e explicações simples para clientes e equipes.</p>
        <a href="#code-architect" class="btn">INICIAR ARQUITETO</a>
    </section>

    <div class="container">
        <section id="about" class="section">
            <h2 class="section-title">> SOBRE MIM</h2>
            <div class="card">
                <p><%= dados['sobre'] %></p>
            </div>
        </section>

        <section id="skills" class="section">
            <h2 class="section-title">> HABILIDADES</h2>
            <div class="card-grid">
                <% dados['habilidades'].each do |skill| %>
                    <div class="card">
                        <h3><%= skill %></h3>
                    </div>
                <% end %>
            </div>
        </section>

        <section id="projects" class="section">
            <h2 class="section-title">> PROJETOS</h2>
            <div class="card-grid">
                <% dados['projetos'].each do |proj| %>
                    <div class="card">
                        <h3><%= proj['nome'] rescue 'Projeto' %></h3>
                        <p><%= proj['descricao'] rescue '' %></p>
                    </div>
                <% end %>
            </div>
        </section>

        <section id="code-architect" class="section">
            <h2 class="section-title">> THE CODE ARCHITECT</h2>
            <div class="card">
                <p style="margin-bottom: 1rem; color: #8b949e;">
                    Cole um trecho de código abaixo e clique em 'Mapear'. A IA extrairá os nós de execução.
                </p>
                <textarea id="codeInput" placeholder="// Cole seu código aqui..."></textarea>
                <button class="btn" onclick="mapearCodigo()">MAPEAR CÓDIGO</button>
                <button class="btn" style="background:#30363d; color:#e6edf3;" onclick="redefinirChave()">ALTERAR CHAVE API</button>
                <div id="output"></div>
            </div>
        </section>
    </div>

    <footer>
        <p>&copy; <%= Time.now.year %> - Desenvolvido para estudos em ADS & Segurança</p>
    </footer>

    <script>
        function obterChaveAPI() {
            let key = localStorage.getItem('GEMINI_API_KEY');
            if (!key) {
                key = prompt("Por favor, informe sua Gemini API Key (começa com AIzaSy):");
                if (key) {
                    localStorage.setItem('GEMINI_API_KEY', key.trim());
                }
            }
            return key;
        }

        function redefinirChave() {
            localStorage.removeItem('GEMINI_API_KEY');
            obterChaveAPI();
        }

        async function mapearCodigo() {
            const code = document.getElementById('codeInput').value;
            const output = document.getElementById('output');
            
            if (!code.trim()) {
                alert('Cole algum código antes de mapear!');
                return;
            }

            const apiKey = obterChaveAPI();
            if (!apiKey) {
                alert('É necessária uma API Key do Gemini para realizar a análise.');
                return;
            }

            output.style.display = 'block';
            output.innerText = 'Analisando código com o Gemini...';

            try {
                const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${apiKey}`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        contents: [{
                            parts: [{
                                text: `Analise o seguinte código e extraia a estrutura de execução (nós, entradas, saídas e possíveis riscos/SQL Injection/vulnerabilidades) em formato JSON limpo:\n\n${code}`
                            }]
                        }]
                    })
                });

                const data = await response.json();
                if (data.candidates && data.candidates[0].content.parts[0].text) {
                    output.innerText = data.candidates[0].content.parts[0].text;
                } else {
                    output.innerText = '❌ Erro ao processar resposta. Verifique a chave configurada.\n' + JSON.stringify(data, null, 2);
                }
            } catch (err) {
                output.innerText = '❌ Erro de conexão com a API do Gemini: ' + err.message;
            }
        }
    </script>

</body>
</html>
HTML

# 3. Compila o template com os dados e salva em index.html
renderer = ERB.new(template_html)
File.write('index.html', renderer.result)
puts "index.html gerado com sucesso!"
