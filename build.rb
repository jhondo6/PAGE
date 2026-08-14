require 'yaml'

# Carrega os dados
dados = YAML.load_file('dados.yml')

# Gera o documento HTML
html_content = <<~HTML
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>#{dados['perfil']['nome']} | Portfólio</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-950 text-slate-100 font-sans min-h-screen">

  <!-- Header / Hero -->
  <header class="max-w-4xl mx-auto pt-16 pb-8 px-6 text-center border-b border-slate-800">
    <h1 class="text-4xl sm:text-5xl font-extrabold tracking-tight bg-gradient-to-r from-emerald-400 to-cyan-500 bg-clip-text text-transparent">
      #{dados['perfil']['nome']}
    </h1>
    <p class="mt-4 text-xl text-slate-400 font-medium">#{dados['perfil']['cargo']}</p>
    
    <div class="mt-6 flex justify-center gap-4">
      <a href="#{dados['perfil']['github']}" target="_blank" class="px-4 py-2 bg-slate-900 border border-slate-800 rounded-lg hover:border-emerald-500 text-sm font-medium transition">GitHub</a>
      <a href="#{dados['perfil']['linkedin']}" target="_blank" class="px-4 py-2 bg-slate-900 border border-slate-800 rounded-lg hover:border-cyan-500 text-sm font-medium transition">LinkedIn</a>
      <a href="mailto:#{dados['perfil']['email']}" class="px-4 py-2 bg-slate-900 border border-slate-800 rounded-lg hover:border-indigo-500 text-sm font-medium transition">Email</a>
    </div>
  </header>

  <main class="max-w-4xl mx-auto px-6 py-12 space-y-12">
    <!-- Sobre Mim -->
    <section class="bg-slate-900/50 p-6 rounded-xl border border-slate-800">
      <h2 class="text-xl font-bold text-emerald-400 mb-3">Sobre Mim</h2>
      <p class="text-slate-300 leading-relaxed">#{dados['perfil']['sobre']}</p>
    </section>

    <!-- Habilidades -->
    <section>
      <h2 class="text-xl font-bold text-cyan-400 mb-4">Habilidades & Conhecimentos</h2>
      <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
        #{dados['skills'].map { |sk| "
          <div class='bg-slate-900 p-4 rounded-xl border border-slate-800'>
            <h3 class='text-sm font-semibold text-slate-200 mb-2'>#{sk['categoria']}</h3>
            <div class='flex flex-wrap gap-1.5'>
              #{sk['itens'].map { |item| "<span class='text-xs bg-slate-800 text-slate-300 px-2 py-1 rounded'>#{item}</span>" }.join}
            </div>
          </div>
        " }.join}
      </div>
    </section>

    <!-- Projetos -->
    <section>
      <h2 class="text-xl font-bold text-indigo-400 mb-4">Projetos em Destaque</h2>
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
        #{dados['projetos'].map { |proj| "
          <div class='bg-slate-900 p-6 rounded-xl border border-slate-800 flex flex-col justify-between hover:border-indigo-500/50 transition'>
            <div>
              <h3 class='text-lg font-semibold text-slate-100'>#{proj['titulo']}</h3>
              <p class='mt-2 text-sm text-slate-400'>#{proj['descricao']}</p>
            </div>
            <div class='mt-4 flex items-center justify-between'>
              <div class='flex gap-1'>
                #{proj['techs'].map { |t| "<span class='text-[10px] bg-slate-800 text-slate-300 px-2 py-0.5 rounded'>#{t}</span>" }.join}
              </div>
              <a href='#{proj['link']}' target='_blank' class='text-xs text-indigo-400 hover:underline'>Ver projeto &rarr;</a>
            </div>
          </div>
        " }.join}
      </div>
    </section>
  </main>
</body>
</html>
HTML

File.write('index.html', html_content)
puts "index.html gerado com sucesso!"
