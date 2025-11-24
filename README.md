# EncaixaFormasiOS
Aplicativo criado para jogar o Encaixa Formas

# Encaixa Formas - iOS Source Code

This folder contains the Swift source code for the Encaixa Formas game.

## How to Run

Since this code was generated on Windows, you need to manually set up the Xcode project on your Mac.

1.  **Create a New Xcode Project**:
    *   Open Xcode.
    *   Select "Create a new Xcode project".
    *   Choose **iOS > App**.
    *   Interface: **Storyboard** (We are using ViewCode, but this is the standard template. We will ignore the storyboard).
    *   Language: **Swift**.
    *   Name it `EncaixaFormas`.

2.  **Add Files**:
    *   Delete `ViewController.swift` from the new project.
    *   Drag and drop the `Source` folder (containing `Models.swift`, `GameEngine.swift`, `PieceView.swift`, etc.) into your Xcode project navigator.
    *   Make sure "Copy items if needed" is checked.

3.  **Configure Entry Point**:
    *   Open `SceneDelegate.swift`.
    *   In `scene(_:willConnectTo:options:)`, replace the content to set `MainViewController` as the root:

    ```swift
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainViewController() // Set our VC
        self.window = window
        window.makeKeyAndVisible()
    }
    ```

4.  **Run**:
    *   Select a Simulator (e.g., iPhone 15).
    *   Press **Cmd + R** to build and run.

## Notes
- The level data in `MainViewController.swift` is a mock. You will need to expand it to match the real game levels.
- The drag-and-drop logic assumes you align the top-left of the piece with the grid.
