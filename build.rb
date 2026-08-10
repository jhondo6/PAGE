require 'yaml'
require 'erb'

dados = YAML.load_file('dados.yml') rescue {}
dados['nome'] ||= "Seu Nome"
dados['sobre'] ||= "Estudante de ADS & Segurança da Informação."

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
        header { background: rgba(13, 17, 23, 0.9); padding: 1rem 2rem; position: fixed; width: 100%; top: 0; border-bottom: 1px solid #30363d; backdrop-filter: blur(10px); display: flex; justify-content: space-between; align-items: center; z-index: 1000; }
        .logo { font-size: 1.2rem; font-weight: bold; color: #00ff66; font-family: monospace; }
        nav a { color: #8b949e; margin-left: 1.5rem; text-decoration: none; }
        nav a:hover { color: #00ff66; }
        .hero { text-align: center; padding: 3rem 2rem; background: radial-gradient(circle at center, #161b22 0%, #06090f 100%); }
        .hero h1 { font-size: 2rem; margin-bottom: 0.5rem; color: #ffffff; }
        .hero p { color: #8b949e; max-width: 600px; margin: 0 auto 1.5rem; }
        .btn { display: inline-block; background: #00ff66; color: #06090f; padding: 0.8rem 1.5rem; border-radius: 6px; font-weight: bold; cursor: pointer; border: none; font-size: 0.95rem; }
        .btn:hover { background: #00cc52; }
        .container { max-width: 1000px; margin: 0 auto; padding: 2rem; }
        .section { margin-bottom: 3rem; }
        .section-title { font-size: 1.4rem; color: #00ff66; margin-bottom: 1rem; border-bottom: 1px solid #30363d; padding-bottom: 0.5rem; }
        .card { background: #0d1117; border: 1px solid #30363d; padding: 1.5rem; border-radius: 8px; }
        input[type="password"] { width: 100%; background: #010409; color: #7ee787; border: 1px solid #30363d; padding: 0.8rem; font-family: monospace; border-radius: 6px; margin-bottom: 1rem; }
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
        <p>Facilitador de código: análise de fluxo, explicação simples e verificação de vulnerabilidades.</p>
    </section>

    <div class="container">
        <section id="about" class="section">
            <h2 class="section-title">> SOBRE</h2>
            <div class="card">
                <p><%= dados['sobre'] %></p>
            </div>
        </section>

        <section id="code-architect" class="section">
            <h2 class="section-title">> FACILITADOR DE CÓDIGO</h2>
            <div class="card">
                <label style="display:block; margin-bottom: 0.5rem; color: #8b949e; font-size: 0.9rem;">
                    Sua Gemini API Key:
                </label>
                <input type="password" id="apiKeyInput" placeholder="Cole sua chave aqui..." />

                <label style="display:block; margin-bottom: 0.5rem; color: #8b949e; font-size: 0.9rem;">
                    Código para Análise:
                </label>
                <textarea id="codeInput" placeholder="// Cole seu código aqui..."></textarea>
                
                <button id="btnMapear" class="btn" type="button">MAPEAR CÓDIGO</button>
                <div id="output"></div>
            </div>
        </section>
    </div>

    <footer>
        <p>&copy; <%= Time.now.year %> - ADS & Segurança</p>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const apiKeyInput = document.getElementById('apiKeyInput');
            const codeInput = document.getElementById('codeInput');
            const btnMapear = document.getElementById('btnMapear');
            const output = document.getElementById('output');

            const savedKey = localStorage.getItem('GEMINI_API_KEY');
            if (savedKey) {
                apiKeyInput.value = savedKey;
            }

            btnMapear.addEventListener('click', async function() {
                const apiKey = apiKeyInput.value.trim();
                const code = codeInput.value.trim();

                if (!apiKey) {
                    alert('Por favor, insira sua API Key no campo superior!');
                    apiKeyInput.focus();
                    return;
                }

                if (!code) {
                    alert('Por favor, cole um código antes de mapear!');
                    codeInput.focus();
                    return;
                }

                localStorage.setItem('GEMINI_API_KEY', apiKey);

                output.style.display = 'block';
                output.innerText = '⏳ Processando e simplificando o código...';

                try {
                    const res = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${apiKey}`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            contents: [{
                                parts: [{
                                    text: "Atue como um facilitador de código e arquiteto de software. Analise o código fornecido e traga uma resposta clara dividida em:\n\n1. RESUMO EXECUTIVO (Explicação simples em linguagem acessível do que o código faz)\n2. FLUXO DE EXECUÇÃO (Passo a passo lógico das entradas até as saídas)\n3. PONTOS ATENÇÃO & SEGURANÇA (Vulnerabilidades como SQL Injection, falhas de validação ou melhorias de código)\n\nCódigo:\n" + code
                                }]
                            }]
                        })
                    });

                    const data = await res.json();
                    if (data.candidates && data.candidates[0].content && data.candidates[0].content.parts[0].text) {
                        output.innerText = data.candidates[0].content.parts[0].text;
                    } else if (data.error) {
                        output.innerText = "❌ Erro na API do Gemini: " + data.error.message;
                    } else {
                        output.innerText = "❌ Resposta não esperada:\n" + JSON.stringify(data, null, 2);
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

renderer = ERB.new(template_html)
File.write('index.html', renderer.result)
puts "index.html gerado com sucesso!"
