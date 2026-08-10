require 'yaml'
require 'erb'

# 1. Carrega os dados do YAML
dados = YAML.load_file('dados.yml') rescue {}
dados['nome'] ||= "Seu Nome"
dados['sobre'] ||= "Estudante de ADS & Segurança da Informação."
dados['habilidades'] ||= ["HTML/CSS", "JavaScript", "Python", "Ruby", "Git/GitHub"]
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
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', monospace, sans-serif; }
        body { background-color: #06090f; color: #e6edf3; line-height: 1.6; padding-top: 80px; }
        a { text-decoration: none; color: inherit; }
        header { background: rgba(13, 17, 23, 0.9); padding: 1rem 2rem; position: fixed; width: 100%; top: 0; border-bottom: 1px solid #30363d; backdrop-filter: blur(10px); display: flex; justify-content: space-between; align-items: center; z-index: 1000; }
        .logo { font-size: 1.2rem; font-weight: bold; color: #00ff66; font-family: monospace; }
        nav a { color: #8b949e; margin-left: 1.5rem; }
        nav a:hover { color: #00ff66; }
        .hero { text-align: center; padding: 4rem 2rem; background: radial-gradient(circle at center, #161b22 0%, #06090f 100%); }
        .hero h1 { font-size: 2.2rem; margin-bottom: 1rem; color: #ffffff; }
        .hero p { color: #8b949e; max-width: 600px; margin: 0 auto 2rem; }
        .btn { display: inline-block; background: #00ff66; color: #06090f; padding: 0.8rem 1.5rem; border-radius: 6px; font-weight: bold; cursor: pointer; border: none; margin-right: 0.5rem; margin-top: 0.5rem; }
        .btn:hover { background: #00cc52; }
        .btn-sec { background: #21262d; color: #c9d1d9; border: 1px solid #30363d; }
        .btn-sec:hover { background: #30363d; }
        .container { max-width: 1000px; margin: 0 auto; padding: 2rem; }
        .section { margin-bottom: 4rem; }
        .section-title { font-size: 1.4rem; color: #00ff66; margin-bottom: 1.5rem; border-bottom: 1px solid #30363d; padding-bottom: 0.5rem; }
        .card { background: #0d1117; border: 1px solid #30363d; padding: 1.5rem; border-radius: 8px; margin-bottom: 1rem; }
        textarea { width: 100%; height: 180px; background: #010409; color: #00ff66; border: 1px solid #30363d; padding: 1rem; font-family: monospace; border-radius: 6px; margin-bottom: 1rem; resize: vertical; }
        #output { background: #010409; border: 1px solid #30363d; padding: 1rem; border-radius: 6px; color: #7ee787; font-family: monospace; white-space: pre-wrap; display: none; margin-top: 1rem; max-height: 400px; overflow-y: auto; }
        footer { text-align: center; padding: 2rem; color: #8b949e; border-top: 1px solid #30363d; font-size: 0.9rem; }
    </style>
</head>
<body>

    <header>
        <div class="logo">{ Code.Architect }</div>
        <nav>
            <a href="#about">Sobre</a>
            <a href="#code-architect">Architect</a>
        </nav>
    </header>

    <section class="hero">
        <h1>The Code Architect</h1>
        <p>Mapeamento de execução, análise de fluxo e verificação de vulnerabilidades via IA.</p>
        <a href="#code-architect" class="btn">USAR FERRAMENTA</a>
    </section>

    <div class="container">
        <section id="about" class="section">
            <h2 class="section-title">> SOBRE</h2>
            <div class="card">
                <p><%= dados['sobre'] %></p>
            </div>
        </section>

        <section id="code-architect" class="section">
            <h2 class="section-title">> ANALISADOR DE CÓDIGO</h2>
            <div class="card">
                <p style="margin-bottom: 1rem; color: #8b949e;">
                    Cole o seu código e clique em <strong>Mapear Código</strong>.
                </p>
                <textarea id="codeInput" placeholder="// Cole seu código aqui..."></textarea>
                <div>
                    <button id="btnMapear" class="btn" type="button">MAPEAR CÓDIGO</button>
                    <button id="btnChave" class="btn btn-sec" type="button">CONFIGURAR CHAVE API</button>
                </div>
                <div id="output"></div>
            </div>
        </section>
    </div>

    <footer>
        <p>&copy; <%= Time.now.year %> - ADS & Segurança</p>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const btnMapear = document.getElementById('btnMapear');
            const btnChave = document.getElementById('btnChave');
            const codeInput = document.getElementById('codeInput');
            const output = document.getElementById('output');

            function obterChave() {
                let key = localStorage.getItem('GEMINI_API_KEY');
                if (!key) {
                    key = prompt("Informe sua Gemini API Key (começa com AIzaSy):");
                    if (key && key.trim() !== "") {
                        localStorage.setItem('GEMINI_API_KEY', key.trim());
                    }
                }
                return key;
            }

            btnChave.addEventListener('click', function() {
                const atual = localStorage.getItem('GEMINI_API_KEY') || '';
                const novaKey = prompt("Informe a nova Gemini API Key:", atual);
                if (novaKey !== null) {
                    localStorage.setItem('GEMINI_API_KEY', novaKey.trim());
                    alert('Chave atualizada com sucesso!');
                }
            });

            btnMapear.addEventListener('click', async function() {
                const code = codeInput.value.trim();
                if (!code) {
                    alert('Por favor, cole algum código antes de clicar em Mapear!');
                    return;
                }

                const apiKey = obterChave();
                if (!apiKey) {
                    alert('Você precisa fornecer uma API Key do Gemini.');
                    return;
                }

                output.style.display = 'block';
                output.innerText = '⏳ Processando análise com a API do Gemini...';

                try {
                    const res = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${apiKey}`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            contents: [{
                                parts: [{
                                    text: "Analise o código abaixo e retorne uma estrutura em JSON simples indicando:\n1. Entradas\n2. Processamento/Fluxo\n3. Riscos de Segurança (ex: SQL Injection, XSS)\n\nCódigo:\n" + code
                                }]
                            }]
                        })
                    });

                    const data = await res.json();
                    if (data.candidates && data.candidates[0].content.parts[0].text) {
                        output.innerText = data.candidates[0].content.parts[0].text;
                    } else if (data.error) {
                        output.innerText = "❌ Erro da API: " + data.error.message;
                    } else {
                        output.innerText = "❌ Resposta inesperada:\n" + JSON.stringify(data, null, 2);
                    }
                } catch (err) {
                    output.innerText = "❌ Erro na requisição: " + err.message;
                }
            });
        });
    </script>

</body>
</html>
HTML

# 3. Gera o arquivo final
renderer = ERB.new(template_html)
File.write('index.html', renderer.result)
puts "index.html gerado com sucesso!"
