return{
    "johannww/tts.nvim",
    cmd = { "TTS", "TTSFile", "TTSSetLanguage", "TTSSetBackend" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        backend = "edge", -- "edge", "openai", or "piper"
        language = "vi",
        speed = 1.0,
        remove_syntax = false,
        syntax_removal_method = "pandoc",
        languages_to_voice = {
            edge = {
                ["en"] = "en-GB-SoniaNeural",
                ["pt"] = "pt-BR-AntonioNeural",
                ["es"] = "es-ES-ElviraNeural",
                ["fr"] = "fr-FR-DeniseNeural",
                ["de"] = "de-DE-KatjaNeural",
                ["it"] = "it-IT-ElsaNeural",
                ["ja"] = "ja-JP-NanamiNeural",
                ["zh"] = "zh-CN-XiaoxiaoNeural",
                ["vi"] = "vi-VN-HoaiMyNeural",
            },
            piper = {
                ["en"] = "en_US-lessac-medium",
                ["pt"] = "pt_BR-faber-medium",
                ["es"] = "es_ES-sharvard-medium",
                ["fr"] = "fr_FR-siwis-medium",
                ["de"] = "de_DE-thorsten-medium",
                ["it"] = "it_IT-riccardo-x_low",
                ["ja"] = "ja_JP-haruka-medium",
                ["zh"] = "zh_CN-huayan-medium",
            },
            -- OpenAI uses the same voice for all languages
            -- Configure in openai option below
        },
        openai = {
            voice = "alloy", -- Available: alloy, ash, ballad, coral, echo, fable, nova, onyx, sage, shimmer
            model = "tts-1", -- "tts-1" or "tts-1-hd"
        },
    },
}
