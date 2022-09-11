enum SceneTransition {
    case root(animated: Bool = true)
    case push(animated: Bool = true)
    case present(animated: Bool = true)
}
