//
// pro_mode_toggle.dart
// PawMind Pro Mode Toggle Widget
//
// UI component for switching between Server Mode and On-Device Pro Mode
//

import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/on_device_service.dart';

/// Pro Mode Toggle Widget
///
/// Shows current mode (Server vs. On-Device) with status indicator
/// Allows user to switch modes in settings
class ProModeToggle extends StatefulWidget {
  const ProModeToggle({Key? key}) : super(key: key);

  @override
  State<ProModeToggle> createState() => _ProModeToggleState();
}

class _ProModeToggleState extends State<ProModeToggle> {
  bool _isProMode = AppConfig.onDeviceEnabled;
  ModelStatus? _modelStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkModelStatus();
    _subscribeToStatusUpdates();
  }

  void _checkModelStatus() async {
    final service = OnDeviceService.instance;
    final status = await service.getModelStatus();
    setState(() {
      _modelStatus = status;
      _isLoading = false;
    });
  }

  void _subscribeToStatusUpdates() {
    OnDeviceService.instance.modelStatusStream.listen((status) {
      if (mounted) {
        setState(() {
          _modelStatus = status;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              _isProMode ? Icons.memory : Icons.cloud,
              color: _isProMode ? Colors.green : Colors.blue,
            ),
            title: Text(
              'On-Device Pro Mode',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text(
              _isProMode
                  ? 'Privacy-first, works offline'
                  : 'Cloud-powered, works on all devices',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Switch(
              value: _isProMode,
              onChanged: _isProModeEnabled ? _toggleProMode : null,
              activeColor: Colors.green,
            ),
          ),
          
          // Status indicator (only shown when Pro Mode enabled)
          if (_isProMode) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildStatusPanel(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusPanel() {
    if (_isLoading) {
      return const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Checking model status...'),
        ],
      );
    }

    final status = _modelStatus;
    if (status == null) {
      return const Text(
        'Unable to load models',
        style: TextStyle(color: Colors.red),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusRow(
          'Vision Model',
          status.visionLoaded,
          'MediaPipe Holistic',
        ),
        const SizedBox(height: 8),
        _buildStatusRow(
          'LLM',
          status.llmLoaded,
          'Phi-3-mini (${status.maxTokens} tokens)',
        ),
        const SizedBox(height: 8),
        _buildStatusRow(
          'TTS',
          status.ttsLoaded,
          'Piper Voice',
        ),
        
        // Device capability warning
        if (!OnDeviceService.isDeviceCapable()) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.amber.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your device may not support on-device mode. iPhone 13+ or Pixel 7+ recommended.',
                    style: TextStyle(
                      color: Colors.amber.shade900,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        
        // Latency info
        if (status.isLoaded) ...[
          const SizedBox(height: 12),
          Text(
            'Expected latency: 2–4 seconds per inference',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusRow(String label, bool isLoaded, String details) {
    return Row(
      children: [
        Icon(
          isLoaded ? Icons.check_circle : Icons.error,
          color: isLoaded ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                details,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _toggleProMode(bool value) async {
    // Show confirmation dialog if enabling Pro Mode
    if (value) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enable Pro Mode?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pro Mode uses on-device AI for:'),
              const SizedBox(height: 8),
              _buildBenefitRow(Icons.security, 'Privacy (no data leaves device)'),
              _buildBenefitRow(Icons.wifi_off, 'Offline capability'),
              _buildBenefitRow(Icons.speed, 'Lower latency (no network)'),
              const SizedBox(height: 16),
              Text(
                'Note: Only available on iPhone 13+ or Pixel 7+. Higher battery usage.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.amber.shade700,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Enable'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
    }

    // Update config
    setState(() {
      _isProMode = value;
    });
    AppConfig.onDeviceEnabled = value;

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Pro Mode enabled - privacy-first on-device AI'
              : 'Server Mode enabled - cloud-powered AI',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}

// MARK: - Feature Flag

/// Whether Pro Mode toggle is enabled in UI
///
/// Set to false during POC development, true when ready for beta
const bool _isProModeEnabled = true;
