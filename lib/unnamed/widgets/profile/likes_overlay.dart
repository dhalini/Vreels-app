import 'package:flutter/material.dart';
import 'package:prototype25/blocs/app/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikesOverlay extends StatelessWidget {
  final String likes;
  const LikesOverlay({Key? key, required this.likes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppBloc>().state;

    return Stack(
      children: [
        
        GestureDetector(
          onTap: () => Navigator.pop(context), 
          child: Container(
            color: Colors.black.withOpacity(0.4), 
          ),
        ),

        
        Center(
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16), 
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width *
                    0.75, 
                maxHeight: MediaQuery.of(context).size.height *
                    0.7, 
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    Image.asset(
                      'assets/heart.png', 
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),

                    
                    const Text(
                      'Total likes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        '${appState.username} received a total of \n $likes likes across all videos',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.4, 
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    
                    const Divider(
                      color: Colors.black12,
                      thickness: 1,
                      height: 1,
                    ),
                    const SizedBox(height: 16),

                    
                    SizedBox(
                      width: double.infinity, 
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
