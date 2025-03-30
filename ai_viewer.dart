import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';

class ARViewerScreen extends StatefulWidget {
  final String postContent;
  
  const ARViewerScreen({super.key, required this.postContent});

  @override
  State<ARViewerScreen> createState() => _ARViewerScreenState();
}

class _ARViewerScreenState extends State<ARViewerScreen> {
  late ARController arController;
  List<ARNode> nodes = [];

  @override
  void dispose() {
    arController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR View'),
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: _onARViewCreated,
            planeDetection: PlaneDetection.horizontal,
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black54,
              child: Text(
                widget.postContent,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onARViewCreated(ARController controller) {
    arController = controller;
    arController.onNodeTap = (node) => _removeNode(node);
    _addTextNode();
  }

  void _addTextNode() {
    final textNode = ARNode(
      type: NodeType.text,
      uri: widget.postContent,
      position: Vector3(0, 0, -1.5),
      scale: Vector3(0.5, 0.5, 0.5),
    );
    
    arController.addNode(textNode);
    nodes.add(textNode);
  }

  void _removeNode(ARNode node) {
    arController.removeNode(node);
    nodes.remove(node);
  }
}
