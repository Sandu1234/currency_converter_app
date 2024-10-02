import 'package:currency_converter_app/main.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to Currency Converter",
          body: "Convert currencies easily with real-time rates.",
          image: Padding(
            padding: const EdgeInsets.only(top: 160.0),
            child: Center(
              child: Lottie.network(
                'https://lottie.host/5f35196c-8cfa-4ddd-a4c6-fbbeff12806c/9joEt0TqPK.json',
                height: 200,
                width: 200,
                repeat: true,
              ),
            ),
          ),
          decoration: PageDecoration(
            pageColor: Colors.blue.shade100,
            titleTextStyle:
                const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            bodyTextStyle: const TextStyle(fontSize: 18.0),
          ),
        ),
        PageViewModel(
          title: "Real-Time Exchange Rates",
          body: "Get live exchange rates and instantly convert any amount.",
          image: Padding(
            padding: EdgeInsets.only(top: 160.0),
            child: Center(
              child: Lottie.network(
                'https://lottie.host/62e93e1e-1b85-4aa0-b18b-368b4ace8edb/8OHFpgPwhX.json',
                height: 200,
                width: 200,
                repeat: true,
              ),
            ),
          ),
          decoration: PageDecoration(
            pageColor: Colors.blue.shade100,
            titleTextStyle:
                const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            bodyTextStyle: const TextStyle(fontSize: 18.0),
          ),
        ),
      ],
      onDone: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CurrencyConverterPage()),
        );
      },
      onSkip: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CurrencyConverterPage()),
        );
      },
      showSkipButton: true,
      skip: const Text(
        "Skip",
        style: TextStyle(color: Colors.black),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.black,
      ),
      done: const Text(
        "Start",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      dotsDecorator: DotsDecorator(
        color: Colors.black26, // Inactive dot color
        activeColor: Colors.black, // Active dot color
        size: const Size.square(10.0),
        activeSize: const Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      dotsContainerDecorator: BoxDecoration(
        color: Colors.blue.shade100, // Updated to match the background color
      ),
    );
  }
}
