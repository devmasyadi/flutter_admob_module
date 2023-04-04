package com.example.flutter_admob_module


import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;


/**
 * my_native_ad.xml can be found at
 * //github.com/googleads/googleads-mobile-flutter/tree/master/packages/google_mobile_ads/example/android/app/src/main/res/layout
 */
class NativeAdFactoryExample(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val nativeAdView = LayoutInflater.from(context).inflate(R.layout.my_native_ad, null) as NativeAdView
        val headlineView = nativeAdView.findViewById<TextView>(R.id.ad_headline)
        val bodyView = nativeAdView.findViewById<TextView>(R.id.ad_body)
        val mediaView = nativeAdView.findViewById<ImageView>(R.id.ad_media)

        headlineView.text = nativeAd.headline
        nativeAdView.headlineView = headlineView

        if (nativeAd.body == null) {
            bodyView.visibility = View.INVISIBLE
        } else {
            bodyView.text = nativeAd.body

            nativeAdView.bodyView = bodyView
        }

        if (nativeAd.images.size > 0) {
            mediaView.setImageDrawable(nativeAd.images[0].drawable)
        } else {
            mediaView.visibility = View.GONE
        }
//        nativeAdView.setMediaContent(nativeAd.mediaContent)

        // Add other asset views as needed
        // For example: CallToAction, Icon, Advertiser, etc.

        nativeAdView.setNativeAd(nativeAd)
        return nativeAdView
    }
}

