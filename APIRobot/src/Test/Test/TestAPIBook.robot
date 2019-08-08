*** Settings ***
Documentation  Documentação da API:  https://fakerestapi.azurewebsites.net/swagger/ui/index#!/Books
Resource  ../Keyword/ResourceAPI.robot
Suite Setup  Connect to my API

*** Test Cases ***
T01-Search all books (GET all books)
  Request all books
  Check status code  200
  Check reason  OK
  Check array length with "200" books


T02-Search a especific book(Get a especific book)
  Request specific book "15"
  Check status code  200
  Check reason  OK
  Check all data from json response body book 15

T03-Register a book(Post a book)
  Register a new book
  Check status code  200
  Check reason  OK

T04-Edit a book(Put request of a book)
  Edit book "0"
  Check status code  200
  Check reason  OK

T05-Delete a book(Delete request of a book)
  Delete book "0"