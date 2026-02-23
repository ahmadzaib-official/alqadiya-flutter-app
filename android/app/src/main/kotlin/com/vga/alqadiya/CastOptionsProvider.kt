package com.vga.alqadiya

import android.content.Context
import com.google.android.gms.cast.framework.CastOptions
import com.google.android.gms.cast.framework.OptionsProvider
import com.google.android.gms.cast.framework.SessionProvider
import com.google.android.gms.cast.framework.media.CastMediaOptions
import com.google.android.gms.cast.framework.media.NotificationOptions

class CastOptionsProvider : OptionsProvider {
    override fun getCastOptions(context: Context): CastOptions {
        // Use the default receiver app ID for basic screen mirroring
        // For custom receiver app, replace with your own app ID
        val receiverApplicationId = "CC1AD845" // Default Media Receiver
        
        return CastOptions.Builder()
            .setReceiverApplicationId(receiverApplicationId)
            .build()
    }
    
    override fun getAdditionalSessionProviders(context: Context): List<SessionProvider>? {
        return null
    }
}
