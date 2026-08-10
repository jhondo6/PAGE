require 'yaml'
require 'erb'

# 1. Carrega os dados do arquivo YAML (Prevenindo erro se não existir)
dados = YAML.load_file('dados.yml') rescue {}

# Define padrões se o YAML falhar ou estiver incompleto
dados['nome'] ||= "Seu Nome"
dados['titulo'] ||= "Estudante de ADS & Segurança"
dados['descricao'] ||= "Focado em Desenvolvimento e Segurança da Informação."
dados['sobre'] ||= "Olá!"
dados['habilidades'] ||= []
dados['projetos'] ||= []

# 2. Template HTML estruturado com ERB
template_html = <<~HTML
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The Code Architect | <%= dados['nome'] %></title>
    <style>
        /* Estilos Base - Mantidos e Atualizados */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background-color: #06090f; color: #e6edf3; line-height: 1.6; padding-top: 80px; }
        a { text-decoration: none; color: inherit; transition: 0.3s; }
        
        /* Header & Logo */
        header { background: rgba(13, 17, 23, 0.9); padding: 1rem 2rem; position: fixed; width: 100%; top: 0; border-bottom: 1px solid #30363d; backdrop-filter: blur(10px); display: flex; justify-content: space-between; align-items: center; z-index: 1000; }
        .logo { font-size: 1.2rem; font-weight: bold; color: #00ff66; font-family: monospace; }
        .logo::before { content: "{ "; }
        .logo::after { content: " } Code.Architect"; }
        nav a { color: #8b949e; margin-left: 1.5rem; }
        nav a:hover, nav a.active { color: #00ff66; }

        /* Hero */
        .hero { min-height: 90vh; display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; padding: 2rem 1rem; background: radial-gradient(circle at center, #0a111a 0%, #06090f 100%); }
        .hero h1 { font-size: 3.5rem; margin-bottom: 0.5rem; color: #ffffff; }
        .hero h1 span { color: #00ff66; }
        .hero p { font-size: 1.3rem; color: #8b949e; max-width: 700px; margin-bottom: 2.5rem; }

        /* Containers e Títulos */
        .container { max-width: 1100px; margin: 0 auto; padding: 4rem 1.5rem; }
        .section-title { text-align: center; font-size: 2rem; margin-bottom: 3rem; color: #ffffff; font-family: monospace; text-transform: uppercase; letter-spacing: 2px; }
        .section-title::before { content: "> "; color: #00ff66; }

        /* Cards */
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem; }
        .card { background: #11151c; border: 1px solid #30363d; border-radius: 8px; padding: 1.5rem; transition: 0.3s; position: relative; }
        .card:hover { transform: translateY(-5px); border-color: #00ff66; box-shadow: 0 5px 15px rgba(0,255,102,0.1); }
        .card h3 { color: #00ff66; margin-bottom: 0.75rem; font-size: 1.25rem; font-family: monospace; }
        .card p { color: #8b949e; font-size: 0.95rem; margin-bottom: 1rem; }

        /* Habilidades */
        .skills-list { display: flex; flex-wrap: wrap; gap: 0.5rem; margin-top: 1rem; }
        .skill-item { background: #161b22; padding: 0.3rem 0.8rem; border-radius: 4px; font-size: 0.8rem; color: #c9d1d9; font-family: monospace; border: 1px solid #30363d; }
        .skill-item:hover { border-color: #00ff66; color: #ffffff; }

        /* --- SEÇÃO DO PROJETO AUTORAL: The Code Architect --- */
        #code-architect { background: #0a111a; border-top: 1px solid #30363d; border-bottom: 1px solid #30363d; }
        .architect-wrapper { display: grid; grid-template-columns: 1fr; gap: 2rem; }
        
        .code-input-area { position: relative; }
        #code-to-process { width: 100%; height: 250px; background: #06090f; color: #c9d1d9; border: 1px solid #30363d; border-radius: 8px; padding: 1rem; font-family: 'Courier New', Courier, monospace; font-size: 0.9rem; resize: none; outline: none; transition: 0.3s; }
        #code-to-process:focus { border-color: #00ff66; box-shadow: 0 0 10px rgba(0,255,102,0.1); }
        
        .architect-controls { display: flex; justify-content: center; gap: 1rem; }
        .btn { padding: 0.75rem 1.5rem; border-radius: 6px; border: none; font-weight: bold; cursor: pointer; transition: 0.3s; font-family: monospace; text-transform: uppercase; }
        .btn-primary { background: #00ff66; color: #0a0e17; }
        .btn-primary:hover { background: #00cc52; transform: scale(1.05); }
        .btn-primary:disabled { background: #30363d; color: #8b949e; cursor: not-allowed; transform: none; }
        
        /* Onde o Mapa 3D será renderizado (Three.js) */
        #map-visualization { background: #06090f; border: 1px solid #30363d; border-radius: 8px; height: 500px; display: flex; justify-content: center; align-items: center; color: #8b949e; position: relative; overflow: hidden; }
        #map-visualization::after { content: "O Mapa Lógico 3D aparecerá aqui após a análise."; font-style: italic; }

        /* Footer */
        footer { text-align: center; padding: 2rem; border-top: 1px solid #30363d; color: #8b949e; font-size: 0.9rem; background: #06090f; }

        /* Responsividade */
        @media (max-width: 768px) {
            header { flex-direction: column; padding: 1rem; }
            nav { margin-top: 1rem; display: flex; flex-wrap: wrap; justify-content: center; gap: 0.5rem; }
            nav a { margin: 0; font-size: 0.9rem; }
            .hero h1 { font-size: 2.2rem; }
            .section-title { font-size: 1.6rem; }
            #map-visualization { height: 300px; }
        }
    </style>
</head>
<body>

    <header>
        <div class="logo"></div>
        <nav>
            <a href="#about">Sobre</a>
            <a href="#skills">Habilidades</a>
            <a href="#projects">Projetos</a>
            <a href="#code-architect">Architect</a>
        </nav>
    </header>

    <section class="hero" id="home">
        <h1>Diagramação Lógica & <span>Mapeamento Visual de Código</span></h1>
        <p>Transforme códigos complexos em mapas interativos e explicações simples para clientes e equipes.</p>
        <a href="#code-architect" class="btn btn-primary">Iniciar Arquiteto</a>
    </section>

    <!-- Outras seções existentes mantidas dinamicamente -->
    <section class="container" id="skills">
        <h2 class="section-title">Habilidades Técnicas</h2>
        <div class="grid">
            <% dados['habilidades'].each do |hab| %>
            <div class="card">
                <h3><%= hab['categoria'] %></h3>
                <p><%= hab['descricao'] %></p>
                <div class="skills-list">
                    <% hab['items'].each do |item| %>
                        <span class="skill-item"><%= item %></span>
                    <% end %>
                </div>
            </div>
            <% end %>
        </div>
    </section>

    <section class="container" id="projects">
        <h2 class="section-title">Destaques do Portfólio</h2>
        <div class="grid">
            <% dados['projetos'].each do |proj| %>
            <div class="card">
                <h3><%= proj['nome'] %></h3>
                <p><%= proj['descricao'] %></p>
            </div>
            <% end %>
        </div>
    </section>

    <!-- --- SEÇÃO DO PROJETO AUTORAL: The Code Architect --- -->
    <section class="container" id="code-architect">
        <h2 class="section-title">The Code Architect</h2>
        <div class="card">
            <h3>Visualizador Lógico de Código</h3>
            <p>Cole seu código (até 50 linhas para este protótipo) abaixo e clique em 'Mapear'. A IA analisará a estrutura técnica e gerará um mapa visual simplificado para explicar o fluxo lógico.</p>
            
            <div class="architect-wrapper">
                <div class="code-input-area">
                    <textarea id="code-to-process" placeholder="// Cole seu código aqui..."></textarea>
                </div>
                
                <div class="architect-controls">
                    <button id="architect-btn" class="btn btn-primary">Mapear Código</button>
                </div>

                <!-- Canvas onde o Three.js desenhará -->
                <div id="map-visualization">
                    <!-- O Canvas do Three.js será injetado aqui -->
                </div>
            </div>
        </div>
    </section>

    <footer>
        <p>&copy; <%= Time.now.year %> - Desenvolvido para estudos em ADS & Segurança | <a href="https://github.com/jhondo6/PAGE">jhondo6/PAGE</a></p>
    </footer>

    <!-- --- SCRIPT JAVASCRIPT: Arquitetura & Integração com IA --- -->
    <script type="module">
        import { GoogleGenerativeAI } from "https://esm.run/@google/generative-ai";

        // --- CONFIGURAÇÃO ---
        // ⚠️ ATENÇÃO: COLOQUE SUA API KEY DO GEMINI AQUI PARA TESTAR LOCALMENTE ⚠️
        const API_KEY = ""; 
        
        const genAI = new GoogleGenerativeAI(API_KEY);
        const model = genAI.getGenerativeModel({ model: "gemini-pro"});

        const codeInput = document.getElementById('code-to-process');
        const architectBtn = document.getElementById('architect-btn');
        const vizArea = document.getElementById('map-visualization');

        architectBtn.addEventListener('click', async () => {
            const code = codeInput.value.trim();
            
            if (!code) {
                alert('Por favor, cole algum código para mapear.');
                return;
            }

            if (code.split('\\n').length > 100) {
                 alert('Por favor, cole um trecho menor (até 100 linhas) para esta versão de teste.');
                 return;
            }

            // Interface em estado de carregamento
            architectBtn.disabled = true;
            architectBtn.innerText = 'Processando...';
            vizArea.innerHTML = ''; // Limpa a área
            vizArea.setAttribute('data-loading', 'true'); // Atributo para estilo de loading se necessário

            // Prompt do Sistema - Define o comportamento da IA como Arquiteto
            const prompt = `
                Você é o "The Code Architect", uma IA especialista em traduzir lógica de programação complexa em diagramas visuais simples para clientes não técnicos.
                Sua tarefa é analisar o código fornecido e retornar uma estrutura JSON simplificada que represente o esqueleto lógico do programa.
                
                Não explique o código em texto. Retorne APENAS um objeto JSON válido com a seguinte estrutura:
                
                {
                  "moduloPrincipal": "Nome do arquivo ou classe principal",
                  "fluxo": [
                    {
                      "tipo": "funcao | variavel | condicional | loop | evento",
                      "nome": "Nome técnico",
                      "explicacaoExecutiva": "Uma frase simples explicando o que isso faz para o cliente."
                    }
                  ],
                  "conexoes": [
                    ["Nome Técnico 1", "Nome Técnico 2"] // Representa qual nó se conecta a qual no fluxo
                  ]
                }

                Código para analisar:
                \`\`\`
                ${code}
                \`\`\`
            `;

            try {
                const result = await model.generateContent(prompt);
                const response = await result.response;
                const jsonText = response.text().replace(/\\`\\`\\`json|\\`\\`\\`/g, '').trim(); // Limpa formatação Markdown
                
                const logicalMap = JSON.parse(jsonText);
                console.log("Mapa Lógico Gerado pela IA:", logicalMap);
                
                // --- PRÓXIMO PASSO (futuro commit): Integrar Three.js aqui ---
                // Para agora, vamos apenas mostrar o JSON bruto para confirmar que a IA funcionou
                vizArea.innerHTML = \`<pre style="font-size: 0.8rem; padding: 1rem; color: #00ff66;">IA respondeu com a estrutura:\\n\${JSON.stringify(logicalMap, null, 2)}</pre>\`;
                vizArea.style.alignItems = "flex-start";
                vizArea.style.overflow = "auto";
                vizArea.removeAttribute('data-loading');

            } catch (error) {
                console.error("Erro na API ou no Parser:", error);
                vizArea.innerHTML = "❌ Erro ao conectar com o Arquiteto de IA ou no processamento do JSON. Verifique sua API Key e tente novamente com um código mais simples.";
            } finally {
                // Restaura o estado da interface
                architectBtn.disabled = false;
                architectBtn.innerText = 'Mapear Código';
            }
        });
    </script>
</body>
</html>
HTML

# 3. Compila o ERB e gera o index.html
renderer = ERB.new(template_html)
resultado = renderer.result(binding)

File.write('index.html', resultado)
puts " Site gerado com sucesso em index.html com o front-end do 'The Code Architect' integrado!"
