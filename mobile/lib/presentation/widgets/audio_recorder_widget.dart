import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:igo_manager/core/constants/app_colors.dart';
import 'package:igo_manager/core/utils/responsive_helper.dart';

enum AudioRecorderState { idle, recording, processing }

class AudioRecorderWidget extends StatefulWidget {
  final void Function(String text) onTranscriptionComplete;

  const AudioRecorderWidget({
    super.key,
    required this.onTranscriptionComplete,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  AudioRecorderState _state = AudioRecorderState.idle;
  bool _available = false;
  String _partialText = '';
  final List<double> _waveformHistory = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    _available = await _speech.initialize();
    if (mounted) setState(() {});
  }

  void _onTap() {
    switch (_state) {
      case AudioRecorderState.idle:
        _startRecording();
      case AudioRecorderState.recording:
        _stopRecording();
      case AudioRecorderState.processing:
        break;
    }
  }

  void _startRecording() async {
    if (!_available) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El dictado por voz no está disponible en este dispositivo'),
          ),
        );
      }
      return;
    }

    setState(() {
      _state = AudioRecorderState.recording;
      _partialText = '';
      _waveformHistory.clear();
    });

    await _speech.listen(
      onResult: (result) {
        if (mounted) {
          setState(() => _partialText = result.recognizedWords);
        }
      },
      onSoundLevelChange: (level) {
        if (mounted) {
          _onSoundLevel(level);
        }
      },
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 60),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
        listenMode: stt.ListenMode.confirmation,
      ),
      localeId: 'es_ES',
    );
  }

  void _onSoundLevel(double level) {
    if (!mounted) return;
    setState(() {
      _waveformHistory.add(level);
      if (_waveformHistory.length > 40) {
        _waveformHistory.removeAt(0);
      }
    });
  }

  void _stopRecording() async {
    await _speech.stop();
    final finalText = _speech.lastRecognizedWords.isNotEmpty
        ? _speech.lastRecognizedWords
        : _partialText;
    if (finalText.isNotEmpty) {
      widget.onTranscriptionComplete(finalText);
    }
    if (mounted) {
      setState(() {
        _state = AudioRecorderState.idle;
        _partialText = '';
        _waveformHistory.clear();
      });
    }
  }

  void _cancelRecording() async {
    await _speech.cancel();
    if (mounted) {
      setState(() {
        _state = AudioRecorderState.idle;
        _partialText = '';
        _waveformHistory.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_state == AudioRecorderState.recording) {
      return _buildRecordingUI();
    }
    return _buildIdleButton();
  }

  Widget _buildIdleButton() {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: S.w(context, 0.14),
        height: S.w(context, 0.14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(Icons.mic, color: Colors.white, size: S.sp(context, 24)),
      ),
    );
  }

  Widget _buildRecordingUI() {
    return Container(
      padding: EdgeInsets.all(S.w(context, 0.03)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _buildPulseDot(),
              SizedBox(width: S.w(context, 0.02)),
              Expanded(
                child: Text(
                  _partialText.isNotEmpty ? _partialText : 'Escuchando...',
                  style: TextStyle(
                    fontSize: S.sp(context, 13),
                    color: Theme.of(context).colorScheme.onSurface,
                    fontStyle:
                        _partialText.isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: S.w(context, 0.02)),
              GestureDetector(
                onTap: _stopRecording,
                child: Container(
                  width: S.w(context, 0.1),
                  height: S.w(context, 0.1),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.error,
                  ),
                  child: Icon(Icons.stop, color: Colors.white, size: S.sp(context, 20)),
                ),
              ),
            ],
          ),
          SizedBox(height: S.h(context, 0.01)),
          SizedBox(
            height: S.h(context, 0.05),
            child: CustomPaint(
              size: Size(double.infinity, S.h(context, 0.05)),
              painter: _WaveformPainter(
                levels: _waveformHistory,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          SizedBox(height: S.h(context, 0.005)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grabando...',
                style: TextStyle(
                  fontSize: S.sp(context, 11),
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              GestureDetector(
                onTap: _cancelRecording,
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    fontSize: S.sp(context, 11),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPulseDot() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Container(
          width: 10 + value * 4,
          height: 10 + value * 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.error.withValues(alpha: 0.5 + value * 0.3),
          ),
        );
      },
      onEnd: () {},
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> levels;
  final Color color;

  _WaveformPainter({required this.levels, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (levels.isEmpty) {
      _drawIdleWaveform(canvas, size);
      return;
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final barCount = math.min(levels.length, 30);
    final barWidth = (size.width / barCount) * 0.6;
    final gap = (size.width / barCount) * 0.4;

    for (int i = 0; i < barCount; i++) {
      final level = levels[i];
      final normalized = (level / 9.0).clamp(0.0, 1.0);
      final barHeight = math.max(4.0, normalized * size.height * 0.9);
      final x = i * (barWidth + gap) + gap / 2;
      final y = (size.height - barHeight) / 2;

      paint.color = color.withValues(alpha: 0.3 + normalized * 0.7);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  void _drawIdleWaveform(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final centerY = size.height / 2;
    final amplitude = size.height * 0.3;

    for (double x = 0; x <= size.width; x += 2) {
      final y = centerY + math.sin(x * 0.3) * amplitude;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) => true;
}
