import 'dart:convert';

import 'package:advice_generator/advice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  Advice initialAdvice = const Advice(id: 0, text: "Press the button to generate advice.");
  Future fetchAdvice() async {
    setState(() {
      loading = true;
    });
    try {
      final response = await Dio().get('https://api.adviceslip.com/advice');
      if (response.statusCode == 200) {
        final slip = jsonDecode(response.data)['slip'];
        setState(() {
          initialAdvice = Advice(id: slip['id'], text: slip['advice']);
          loading = false;
        });
      } else {
        setState(() {
          initialAdvice = const Advice(id: 0, text: "We couldn't fetch the advice. Please try again later.");
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        initialAdvice = const Advice(id: 0, text: "We couldn't fetch the advice. Please try again later.");
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 500) {
      width = 500;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Advice Generator"),
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.format_quote),
                          Text(
                            "Advice #${initialAdvice.id}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Icon(Icons.format_quote),
                        ],
                      ),
                    ),
                    Text(
                      initialAdvice.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: loading ? null : fetchAdvice,
          label: Text(loading ? "Loading..." : "Generate Advice"),
          icon: loading ? const CircularProgressIndicator.adaptive() : const Icon(Icons.grid_3x3),
        ));
  }
}