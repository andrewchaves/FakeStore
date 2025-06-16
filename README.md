# FakeStore

FakeStore is an iOS e-commerce application developed using UIKit. 

The project follows clean architecture principles by separating the business logic into a standalone Swift package: [FakeStoreCore](https://github.com/andrewchaves/FakeStoreCore). The `FakeStoreCore` package manages data persistence, repositories, and domain models, while this repository is fully focused on the presentation layer and UIKit-based UI components.

This structure allows better modularization, reusability, and makes it easier to maintain and evolve the codebase. The business logic package can also be reused in alternative versions of the app, such as a SwiftUI implementation currently under development.

> This project is still a work in progress and will continue to evolve as new features are implemented.

