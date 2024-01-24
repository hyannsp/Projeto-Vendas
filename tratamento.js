const fs = require('fs');

function lerJson(caminho) {
    try {
        // Verifica se o arquivo existe antes de ler
        if (fs.existsSync(caminho)) {
            // Lê o conteúdo do arquivo e converte para objeto js
            const dados = JSON.parse(fs.readFileSync(caminho, 'utf-8'));
            console.log('Dados lidos do arquivo JSON:', dados);
            return tratamentoNomes(dados);
        } else {
            console.error('Arquivo JSON não encontrado:', caminho);
            return null;
        }
    } catch (erro) {
        console.error('Erro ao ler o arquivo JSON:', erro.message);
        return null;
    }
}

function tratamentoNomes(dados) {
    const chaves = Object.keys(dados);
    chaves.forEach(chave => {
        const valor = dados[chave];
        if (typeof valor === 'object' && valor !== null) {
            // Utilizei do padrão UNICODE para representar ø e æ 
            if('nome' in valor){
                valor['nome'] = valor['nome'].replace(/\u00F8/gi, 'o').replace(/\u00E6/gi, 'a');
            }
            else if('marca' in valor){
                valor['marca'] = valor['marca'].replace(/\u00F8/gi, 'o').replace(/\u00E6/gi, 'a');
            }
        }
    });
    return dados;
}

function tratamentoVendas(dados){
    const chaves = Object.keys(dados);

    chaves.forEach(chave => {
        const valor = dados[chave];
        if (typeof valor === 'object' && valor !== null && typeof valor['vendas'] === 'string') {
            valor['vendas'] = parseInt(valor['vendas']);
        }

    });
    return dados;
}

function exportarJson(caminho, dados){
    try {
        const dadosJson = JSON.stringify(dados, null, 2);
        fs.writeFileSync(caminho, dadosJson, 'utf-8');
        console.log(`Dados salvos no arquivo JSON: ${caminho}`);
    } catch (erro) {
        console.error('Erro ao salvar o arquivo JSON:', erro.message);
    }
}

const caminho1 = './Dados/broken_database_1.json';
const caminho2 = './Dados/broken_database_2.json';

let veiculos = lerJson(caminho1)
let marcas = lerJson(caminho2)

tratamentoVendas(veiculos)

exportarJson('./Dados/fixed_database_1.json', veiculos);
exportarJson('./Dados/fixed_database_2.json', marcas);