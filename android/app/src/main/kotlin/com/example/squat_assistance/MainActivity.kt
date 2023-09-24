package com.example.squat_assistance

import io.flutter.embedding.android.FlutterActivity

import android.Manifest
import android.os.Bundle
import android.os.Build
import android.content.Context
import androidx.core.app.ActivityCompat
import android.content.pm.PackageManager
import androidx.annotation.RequiresApi
import android.widget.Toast

class MainActivity: FlutterActivity() {

    val PERMISSIONS = arrayOf(
        Manifest.permission.ACCESS_FINE_LOCATION
    )
    val PERMISSIONS_S_ABOVE = arrayOf(
        Manifest.permission.BLUETOOTH_SCAN,
        Manifest.permission.BLUETOOTH_CONNECT,
        Manifest.permission.ACCESS_FINE_LOCATION
    )
    val REQUEST_ALL_PERMISSION = 2
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S){
            if (!hasPermissions(this, PERMISSIONS_S_ABOVE)) {
                requestPermissions(PERMISSIONS_S_ABOVE, REQUEST_ALL_PERMISSION)
            }
        }else{
            if (!hasPermissions(this, PERMISSIONS)) {
                requestPermissions(PERMISSIONS, REQUEST_ALL_PERMISSION)
            }
        }
    }
    
    private fun hasPermissions(context: Context, permissions: Array<String>): Boolean {
            for (permission in permissions) {
                if (ActivityCompat.checkSelfPermission(context, permission)
                    != PackageManager.PERMISSION_GRANTED
                ) {
                    return false
                }
            }
        return true
    }
    
    // Permission check
    @RequiresApi(Build.VERSION_CODES.M)
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String?>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            REQUEST_ALL_PERMISSION -> {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    Toast.makeText(this, "Permissions granted!", Toast.LENGTH_SHORT).show()
                } else {
                    requestPermissions(permissions, REQUEST_ALL_PERMISSION)
                    Toast.makeText(this, "Permissions must be granted", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }
}
