# Laboratorul 4 - Medical Appointment

Aplicatie Flutter care foloseste servicii Web HTTP, serializare JSON, Cubit si
Clean Architecture.

## API

- Feed: `https://test-api-jlbn.onrender.com/lab2026/v2/feed`
- Detalii: `https://test-api-jlbn.onrender.com/lab2026/v2/feed/details`

API-ul este de tip read-only si accepta operatii GET. Selectarea unei
programari este pastrata doar in memoria aplicatiei.

## Arhitectura

```text
Presentation -> Domain -> Data -> REST API
```

- `presentation`: ecrane, widgeturi, Cubit si stari
- `domain`: entitati, contractul Repository si Use Cases
- `data`: modele JSON, Remote Data Source si implementarea Repository

## Fluxul datelor

1. Interfata apeleaza o metoda din Cubit.
2. Cubit apeleaza un Use Case.
3. Use Case foloseste contractul Repository.
4. Repository acceseaza Remote Data Source.
5. Remote Data Source executa cererea HTTP GET.
6. JSON-ul este deserializat intr-un model Dart.
7. Cubit emite Loading, Success, Empty sau Error.
8. BlocBuilder reconstruieste interfata.

## Rulare

```bash
flutter pub get
flutter run
```

## Verificare

```bash
flutter analyze
flutter test
```
