package io.petros.kmp.ai

import androidx.compose.ui.window.Window
import androidx.compose.ui.window.application

fun main() = application {
    Window(
        onCloseRequest = ::exitApplication,
        title = "KMP and AI",
    ) {
        App()
    }
}