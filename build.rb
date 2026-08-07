require 'yaml'
require 'erb'

# 1. Carrega os dados do arquivo YAML
dados = YAML.load_file('dados.yml')

# 2. Template HTML estruturado com ERB
template_html = <<~HTML
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portfólio | <%= dados['nome'] %></title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background-color: #0a0e17; color: #e6edf3; line-height: 1.6; }
        header { background: rgba(13, 17, 23, 0.9); padding: 1.5rem 2rem; position: fixed; width: 100%; top: 0; border-bottom: 1px solid #30363d; backdrop-filter: blur(10px); display: flex; justify-content: space-between; align-items: center; z-index: 100; }
        .logo { font-size: 1.2rem; font-weight: bold; color: #00ff66; font-family: monospace; }
        nav a { color: #8b949e; text-decoration: none; margin-left: 1.5rem; }
        nav a:hover { color: #00ff66; }
        .hero { min-height: 100vh; display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; padding: 6rem 1rem 2rem 1rem; background: radial-gradient(circle at center, #111b27 0%, #0a0e17 100%); }
        .profile-img { width: 150px; height: 150px; border-radius: 50%; border: 2px solid #00ff66; object-fit: cover; margin-bottom: 1.5rem; box-shadow: 0 0 15px rgba(0, 255, 102, 0.2); }
        .hero h1 { font-size: 3rem; margin-bottom: 0.5rem; }
        .hero h1 span { color: #00ff66; }
        .hero p { font-size: 1.2rem; color: #8b949e; max-width: 600px; margin-bottom: 2rem; }
        .tag-badge { background: rgba(0, 255, 102, 0.1); color: #00ff66; padding: 0.4rem 1rem; border-radius: 20px; border: 1px solid rgba(0, 255, 102, 0.3); font-family: monospace; margin-bottom: 1.5rem; }
        .container { max-width: 1100px; margin: 0 auto; padding: 5rem 1.5rem; }
        .section-title { text-align: center; font-size: 2rem; margin-bottom: 3rem; color: #ffffff; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem; }
        .card { background: #161b22; border: 1px solid #30363d; border-radius: 8px; padding: 1.5rem; }
        .card h3 { color: #00ff66; margin-bottom: 0.5rem; }
        .card p { color: #8b949e; font-size: 0.95rem; }
        .skills-list { display: flex; flex-wrap: wrap; gap: 0.5rem; margin-top: 1rem; }
        .skill-item { background: #21262d; padding: 0.3rem 0.8rem; border-radius: 4px; font-size: 0.85rem; color: #c9d1d9; font-family: monospace; }
        footer { text-align: center; padding: 2rem; border-top: 1px solid #30363d; color: #8b949e; font-size: 0.9rem; }
    </style>
</head>
<body>
    <header>
        <div class="logo">&gt; dev_security.sh_</div>
        <nav>
            <a href="#sobre">Sobre</a>
            <a href="#skills">Habilidades</a>
            <a href="#projetos">Projetos</a>
        </nav>
    </header>

    <section class="hero">
        <img src="minha-foto.jpg" alt="Minha Foto" class="profile-img">
        <div class="tag-badge"><%= dados['titulo'] %></div>
        <h1>Construindo Sistemas & <span>Explorando Vulnerabilidades</span></h1>
        <p><%= dados['descricao'] %></p>
    </section>

    <section class="container" id="sobre">
        <h2 class="section-title">/sobre_mim</h2>
        <div class="card">
            <p><%= dados['sobre'] %></p>
        </div>
    </section>

    <section class="container" id="skills">
        <h2 class="section-title">/habilidades</h2>
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

    <section class="container" id="projetos">
        <h2 class="section-title">/projetos</h2>
        <div class="grid">
            <% dados['projetos'].each do |proj| %>
            <div class="card">
                <h3><%= proj['nome'] %></h3>
                <p><%= proj['descricao'] %></p>
            </div>
            <% end %>
        </div>
    </section>

    <footer>
        <p>&copy; <%= Time.now.year %> - Desenvolvido para estudos em ADS & Segurança</p>
    </footer>
</body>
</html>
HTML

# 3. Compila o ERB e gera o index.html
renderer = ERB.new(template_html)
resultado = renderer.result(binding)

File.write('index.html', resultado)
puts " Site gerado com sucesso em index.html!"
