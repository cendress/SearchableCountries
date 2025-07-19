# SearchableCountries

## Project Overview
**SearchableCountries** is a native iOS app that fetches a list of countries from a remote JSON endpoint and displays them in a searchable table view. Built with UIKit, Combine, and the MVVM pattern, this app demonstrates clean architecture, programmatic UI (no storyboards), dynamic type support, and unit testing.

## Video
https://github.com/user-attachments/assets/4a2ecca7-dd86-457e-a450-e5be820db8b5

## Architecture
The app follows the **Model–View–ViewModel (MVVM)** architecture, ensuring a clear separation of concerns and easy testability.

### Key Components
- **Model (`Country`, `Currency`, `Language`)**  
  Plain Swift structs conforming to `Codable`, representing the JSON payload.

- **Service (`CountryService`)**  
  - `CountryService` (protocol + concrete) handles network fetching via Combine and JSON decoding.  

- **ViewModel (`CountryListViewModel`)**  
  - Exposes `@Published` properties:  
    - `countries` (raw data)  
    - `filtered` (search results)  
    - `searchText` (bound from the UI)  
    - `errorMessage` (for error handling)  
  - Binds the Combine pipeline: when `countries` or `searchText` changes, it recomputes `filtered`.

- **View (`CountryListViewController`, `CountryCell`)**  
  - Programmatic `UITableView` inside a `UIViewController`, with a `UISearchController` in the navigation bar.  
  - `CountryCell` lays out name/region/code headline, and capital subheadline, all with Dynamic Type support.

## Design Decisions

### UI & UX
- **Programmatic Layout** — Full Auto Layout with `NSLayoutConstraint` and layout guides, no `.xib` or storyboard.  
- **Dynamic Type** — Uses `UIFont.preferredFont(forTextStyle:)` and `adjustsFontForContentSizeCategory`.  
- **Search-as-You-Type** — `UISearchController` drives real-time filtering via Combine.

### Networking & Combine
- **Combine Pipelines** — Clean mapping from network response → model → published arrays.  
- **Error Handling** — Network errors surface as `errorMessage` and display a user-friendly alert.

### Testability
- **Dependency Injection** — Services conform to protocols, allowing injection of `MockCountryService` in tests.  
- **Synchronous “Just” Publisher** — Enables simple, deterministic unit tests without expectations or waits.

## Setup Instructions
1. **Clone the repo**  
   ```bash
   git clone https://github.com/yourusername/SearchableCountries.git
   cd SearchableCountries

## Screenshots
<img width="1290" height="2796" alt="01" src="https://github.com/user-attachments/assets/847d8985-f1cd-450f-8457-7768615cceaa" />
<img width="1290" height="2796" alt="02" src="https://github.com/user-attachments/assets/22f75d53-9ee0-4a99-808f-a57ba46921ed" />
