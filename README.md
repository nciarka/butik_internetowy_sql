# Projekt bazy danych – butik internetowy

Ten projekt stworzyłam w ramach studiów na kierunku Informatyka.  
Jego celem było zaprojektowanie i zbudowanie bazy danych dla sklepu internetowego – od modelu koncepcyjnego po gotowy skrypt SQL.

## Zawartość repozytorium:

- `butik_internetowy.sql` – gotowy skrypt tworzący całą bazę: tabele, relacje, procedury, triggery i widok
- `dokumntacja_projektu_butik_internetowy.pdf` – dokument z opisem projektu, jego byty, relacje, założenia, dane testowe

## Funkcje bazy danych:

- rejestruje klientów z unikalnym adresem e-mail
- pozwala przeglądać produkty i kategorie
- umożliwia składanie zamówień z wieloma produktami
- obsługuje płatności i zapisuje historię transakcji
- zapisuje działania w logach
- ma widok SQL z danymi o zamówieniach i płatnościach

## Uruchomienie:

1. Utwórz bazę danych `BUTIK_INTERNETOWY`
2. Wgraj skrypt `butik_internetowy.sql` do środowiska SQL Server (np. SSMS)
3. Możesz testować procedury (np. `DodajKlienta`) i korzystać z widoku `DaneZamowien`

## Autor

Natalia Ciarka  
GitHub: [nciarka](https://github.com/nciarka)


## English version

# Database project – Online boutique

This project was created as part of my studies in Computer Science.  
The goal was to design and build a database for an online store – from a conceptual model to a complete SQL script.

## Repository contents:

- `butik_internetowy.sql` – a ready-to-run script that creates the entire database: tables, relationships, stored procedures, triggers and a view
- `dokumntacja_projektu_butik_internetowy.pdf` – documentation with project description, entities, relationships, assumptions and test data

## Database functionalities:

- registers clients with a unique email address
- allows browsing products and categories
- supports placing orders with multiple products
- handles payments and stores transaction history
- logs system operations
- includes a SQL view with order and payment data

## How to run:

1. Create a database named `BUTIK_INTERNETOWY`
2. Execute the `butik_internetowy.sql` script in SQL Server (e.g. SSMS)
3. You can test procedures (e.g. `DodajKlienta`) and use the `DaneZamowien` view

## Author

Natalia Ciarka  
GitHub: [nciarka](https://github.com/nciarka)
