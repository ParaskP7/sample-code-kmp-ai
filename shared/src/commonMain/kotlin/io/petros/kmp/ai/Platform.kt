package io.petros.kmp.ai

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform