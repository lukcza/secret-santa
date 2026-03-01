import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:secret_santa/core/theme/app_theme.dart';
class CurrencyChooser extends StatefulWidget {
  const CurrencyChooser({super.key});

  @override
  State<CurrencyChooser> createState() => _CurrencyChooserState();
}

class _CurrencyChooserState extends State<CurrencyChooser> {
  late String selectedCurrency ;
  late List<String> filteredCurrencies;
  @override
  void initState() {
    super.initState();
    selectedCurrency = 'EUR';
    filteredCurrencies = _getAllCurrencies();
  }
  List<String> _getAllCurrencies() {
    return [
      'USD', 'EUR', 'GBP', 'JPY', 'CNY', 'INR', 'CHF', 'CAD', 'AUD', 'NZD',
      'MXN', 'SGD', 'HKD', 'NOK', 'SEK', 'DKK', 'PLN', 'CZK', 'HUF', 'RON',
      'BGN', 'HRK', 'RUB', 'TRY', 'BRL', 'ZAR', 'AED', 'SAR', 'KWD', 'QAR',
    ];
  }
  void _filterCurrencies(String query) {
    setState(() {
      if(query.isEmpty) {
        filteredCurrencies = _getAllCurrencies();
      } else {
        filteredCurrencies = _getAllCurrencies().where((currency) => currency.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(searchBarTheme: AppTheme.searchBarTheme),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            onTap: () {
              controller.openView();
            },
            onChanged: (query) {
              controller.openView();
            },
            leading: const Icon(Icons.attach_money),
            hintText: selectedCurrency,
          );
        },
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              _filterCurrencies(controller.text);
              return filteredCurrencies.map((currency) {
                return ListTile(
                  title: Text(currency),
                  onTap: () {
                    setState(() {
                      selectedCurrency = currency;
                    });
                    controller.closeView(currency);
                  },
                );
              });
            },
          ),
    );
      }
  }