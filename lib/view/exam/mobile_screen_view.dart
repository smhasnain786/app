import 'package:flutter/material.dart';
import 'package:ready_lms/view/home_tab/home_tab.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ready_lms/view/courses/course_tab/course_tab_screen.dart';

class MobileViewScreen extends StatefulWidget {
  final String url;

  const MobileViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  _MobileViewScreenState createState() => _MobileViewScreenState();
}

class _MobileViewScreenState extends State<MobileViewScreen> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'flutter_inappwebview',
        onMessageReceived: (message) {
          print('Received message: ${message.message}');
          if (message.message == 'navigateToFlutterScreen') {
            // Navigate to the Flutter screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeTab(),
              ),
            );
          }
        },
      )
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          if (progress < 100) {
            setState(() {
              isLoading = true;
            });
          }
        },
        onPageStarted: (url) {
          setState(() {
            isLoading = true;
          });
        },
        onPageFinished: (url) {
          _setupDynamicLinkDetection();
          setState(() {
            isLoading = false;
          });
        },
        onWebResourceError: (error) {
          print("WebView Error: ${error.description}");
          setState(() {
            isLoading = false;
          });
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _setupDynamicLinkDetection() async {
    try {
      await controller.runJavaScript('''
        console.log('Dynamic link detection script injected');
        
        // Function to check and process the link
        function checkForViewResultsLink() {
          console.log('Checking for View Results link');
          
          // Try to find the link by ID first
          let viewResultLink = document.getElementById('view_result');
          
          // If not found by ID, search in main document and iframe
          if (!viewResultLink) {
            // Check in main document first
            viewResultLink = Array.from(document.querySelectorAll('a'))
              .find(a => a.textContent.trim().toLowerCase().includes('view results'));
            
            // If not found in main document, check in iframe
            if (!viewResultLink) {
              const iframe = document.querySelector('iframe');
              if (iframe) {
                console.log('Checking iframe');
                const iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
                viewResultLink = Array.from(iframeDoc.querySelectorAll('a'))
                  .find(a => a.textContent.trim().toLowerCase().includes('view results'));
              }
            }
          }
          
          if (viewResultLink) {
            console.log('View Results link found');
            
            // Update button text
            viewResultLink.textContent = 'Go Back';
            
            // Change the onclick event to trigger Flutter navigation
            viewResultLink.onclick = function() {
              window.flutter_inappwebview.postMessage('navigateToFlutterScreen');
            };
            
            return true;
          }
          
          console.log('View Results link not found');
          return false;
        }
        
        // Continuous checking mechanism
        function startLinkDetection() {
          let attempts = 0;
          const maxAttempts = 5000000; // Adjust based on expected delay
          const interval = 2000; // Check every 1000ms
          
          const checkInterval = setInterval(() => {
            attempts++;
            
            if (checkForViewResultsLink()) {
              // Link found, stop checking
              clearInterval(checkInterval);
            }
            
            // Stop after maximum attempts
            if (attempts >= maxAttempts) {
              clearInterval(checkInterval);
              console.log('Stopped checking after maximum attempts');
            }
          }, interval);
        }
        
        // Start the detection process
        startLinkDetection();
        
        // Also set up a MutationObserver as a fallback
        const observer = new MutationObserver((mutationsList) => {
          checkForViewResultsLink();
        });

        // Observe the entire document
        observer.observe(document.body, {
          childList: true,
          subtree: true,
          attributes: true
        });
      ''');
    } catch (e) {
      print("Error setting up dynamic link detection: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start Exam')),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class NewScreen extends StatelessWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Screen")),
      body: const Center(child: Text("This is the new screen!")),
    );
  }
}
