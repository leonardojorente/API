*** Settings ***
Documentation  Documentação da API:  https://fakerestapi.azurewebsites.net/swagger/ui/index#!/Books
Library  RequestsLibrary
Library  Collections

#cd C:\Python27\Scripts
#pip install robotframework-requests
#pip freeze -- para checar as versões


*** Variables ***
${URL_API}  https://fakerestapi.azurewebsites.net/api/
#criando um dicionário do books 15 e passando os argumentos
https://fakerestapi.azurewebsites.net/swagger/ui/index#!/Books/Books_Get_0
&{BOOK_15}  ID=15
...         Title=Book 15
...         Description=Lorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\r\n
...         PageCount=1500
...         Excerpt=Lorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\r\nLorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\r\nLorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\r\nLorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\r\nLorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\r\n


*** Keywords ***
###SETUP AND TEARDOWN
Connect to my API
#Create session faz uma conexao entre robot e a API desejada
#fakeAPi = alias, um apelido para a api que estamos nos conectando
  Create Session  fakeAPI  ${URL_API}
############################################################################
###Actions
Request all books
#pegamos o alias da API que estamos nos conectados e o end point, assim a requisição url + end point fica
#https://fakerestapi.azurewebsites.net/api/books
  ${RESPONSE}  Get Request   fakeAPI  Books
#RESPONSE.text é o equivalente ao response body, bom para checagem de log, para navegar nos itens request.json é melhor
  Log        ${RESPONSE.text}
  #Transforma a variavel RESPONSE em uma variável de teste
  set test variable  ${RESPONSE}

Request specific book "${ID_BOOK}"
#Sempre que o resultado do json estiver entre chaves, é um dicionário
  ${RESPONSE}  Get Request   fakeAPI  Books/${ID_BOOK}
  Log        ${RESPONSE.text}
  set test variable  ${RESPONSE}

Register a new book
  ${HEADERS}   Create Dictionary  content-type=application/json
  ${RESPONSE}  Post request       fakeAPI  Books
  #... equivale a epaço duplo, portanto ainda estou escrevento os parametros de entrada do post request
  #quando uso data=, estou especificando exatamente qual o parametro de entrada que será preenchid, no caso, o data
  ...                             data={"ID": 0,"Title": "string","Description": "string","PageCount": 0,"Excerpt": "string","PublishDate": "2019-07-28T18:25:47.778Z"}
  ...                             headers=${HEADERS}
  Log          ${RESPONSE.text}
  Set test Variable  ${RESPONSE}


Edit book "${ID_BOOK}"
  ${HEADERS}   Create Dictionary  content-type=application/json
  ${RESPONSE}  Put request       fakeAPI  Books/${ID_BOOK}
  #... equivale a epaço duplo, portanto ainda estou escrevento os parametros de entrada do post request
  #quando uso data=, estou especificando exatamente qual o parametro de entrada que será preenchid, no caso, o data
  ...                             data={"ID": 0,"Title": "edited string","edited Description": "string","PageCount": 0,"Excerpt": "string","PublishDate": "2019-07-28T18:25:47.778Z"}
  ...                             headers=${HEADERS}
  Log          ${RESPONSE.text}
  Set test Variable  ${RESPONSE}

Delete book "${ID_BOOK}"
  ${RESPONSE}  Delete request       fakeAPI  Books/${ID_BOOK}
  Log          ${RESPONSE.text}

##############################################################################
###Checks
Check status code
#compara o status code 200 = ok
  [Arguments]  ${STATUSCODE_EXPECTED}
  should be equal as strings  ${RESPONSE.status_code}  ${STATUSCODE_EXPECTED}


Check reason
  [Arguments]  ${REASON_EXPECTED}
  should be equal as strings  ${RESPONSE.reason}  ${REASON_EXPECTED}

Check array length with "${NUMBER_OF_BOOKS}" books
#{"ID": 1,...},{"ID": 2,...} indica uma lista no body, estou checando a quantidade de elementos
#Length should be  ${RESPONSE.text}
  Length should be  ${RESPONSE.json()}  ${NUMBER_OF_BOOKS}

Check all data from json response body book 15
  Dictionary should contain item  ${RESPONSE.json()}  ID           ${BOOK_15.ID}
  Dictionary should contain item  ${RESPONSE.json()}  Title        ${BOOK_15.Title}
  Dictionary should contain item  ${RESPONSE.json()}  Description  ${BOOK_15.Description}
  Dictionary should contain item  ${RESPONSE.json()}  PageCount    ${BOOK_15.PageCount}
  Dictionary should contain item  ${RESPONSE.json()}  Excerpt      ${BOOK_15.Excerpt}
  should not be empty             ${RESPONSE.json()["PublishDate"]}