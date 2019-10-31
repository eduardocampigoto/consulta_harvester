# consulta_harvester
Script powershell para auxiliar na consulta de informações de contatos em massa utilizando o the_harvester

<b>DESCRIÇÃO</b>

<p>Este script foi criado com intuito de poupar tempo na execução da prospecção de clientes utilizando o script the_harvester como background das consultas, automatizando a execução de várias consultas ao mesmo tempo.

Com ele é possível buscar listas de nomes e cargos de contatos, emails e outras informações baseadas na busca executada pelo the_harvester no facebook, linkedin, twitter, dentre outros.
</p>
<b>OBSERVAÇÕES</b>
<p>
As informações coletadas estão públicas na internet, por isso algumas podem não ter resultados satisfatórios

Como o harvester é uma ferramenta utilizada para pentest, além de informações de contato serão trazidas informações de IP, domínios, subdomínios e servidores.

Por estarem públicas na internet não há nenhuma barreira com a coleta das informações, porém, a utilização das informações coletadas com o script é de responsabilidade do usuário. 


Use com responsabilidade

</p>
<b>EXECUÇÃO</b>
<p>
Para executa-lo, é necessário baixar e instalar ter o harvester(<a href="https://github.com/laramies/theHarvester">link</a>) e  editar  a primeira  linha do script indicando a pasta onde o script do harvester está instalado.

Ex.: $global:theharvester="C:\theHarvester\theHarvester.py"
</p>
<b>CONSULTAS</b> 
<p>

- Para executar consultas de uma única empresa, selecione a primeira opção do script e digite o domínio para qual deseja obter informações.

- Para executar consultas de várias empresas, selecione a segunda opção do script e aponte o caminho do documento de texto que contem a lista de domínios no seguinte formato:

empresa1.com.br</br>
empresa2.com</br>
empresa3.com.br</br>
empresa4.com.br</br>


<b>Obs.: O tempo de execução vai variar de acordo com a quantidade de buscas sendo executadas, podendo levar horas por haver um delay necessário para não haver bloqueios na consulta.</b>
</p>
