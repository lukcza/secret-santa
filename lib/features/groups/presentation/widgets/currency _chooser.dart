import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:secret_santa/core/theme/app_theme.dart';

class CurrencyChooser extends StatefulWidget {
  const CurrencyChooser({super.key});

  @override
  State<CurrencyChooser> createState() => _CurrencyChooserState();
}

class _CurrencyChooserState extends State<CurrencyChooser> {
  late String selectedCurrency;
  late String selectedCurrencySign;
  late List<String> filteredCurrencies;
  @override
  void initState() {
    super.initState();
    selectedCurrency = _getLocalCurrency();
    filteredCurrencies = _getAllCurrencies();
    selectedCurrencySign = _getAllCurrenciesSign()[
        _getAllCurrencies().indexOf(selectedCurrency)];
  }

  String _getLocalCurrency(){
    final locale = Platform.localeName;
    if (locale.startsWith('en')) {
      return 'USD';
    } else if (locale.startsWith('de')) {
      return 'EUR';
    } else if (locale.startsWith('fr')) {
      return 'EUR';
    } else if (locale.startsWith('it')) {
      return 'EUR';
    } else if (locale.startsWith('es')) {
      return 'EUR';
    } else if (locale.startsWith('pt')) {
      return 'BRL';
    } else if (locale.startsWith('ja')) {
      return 'JPY';
    } else if (locale.startsWith('zh')) {
      return 'CNY';
    } else {
      return 'USD';
    }
  }

  List<String> _getAllCurrenciesSign() {
    return [
      '\$',
      '€',
      '£',
      '¥',
      '¥',
      '₹',
      'Fr.',
      '\$',
      '\$',
      '\$',
      '\$',
      '\$',
      '\$',
      'kr',
      'kr',
      'kr',
      'zł',
      'Kč',
      'Ft',
      'lei',
      'лв.',
      'kn',
      '₽',
      '₺',
      'R\$',
      'R\$',
      'د.إ',
      'ر.س',
      'د.ك',
      'ر.ق',
    ];
  }

  List<String> _getAllCurrencies() {
    return [
      'USD',
      'EUR',
      'GBP',
      'JPY',
      'CNY',
      'INR',
      'CHF',
      'CAD',
      'AUD',
      'NZD',
      'MXN',
      'SGD',
      'HKD',
      'NOK',
      'SEK',
      'DKK',
      'PLN',
      'CZK',
      'HUF',
      'RON',
      'BGN',
      'HRK',
      'RUB',
      'TRY',
      'BRL',
      'ZAR',
      'AED',
      'SAR',
      'KWD',
      'QAR',
    ];
  }

  void _filterCurrencies(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCurrencies = _getAllCurrencies();
      } else {
        filteredCurrencies =
            _getAllCurrencies()
                .where(
                  (currency) =>
                      currency.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
      selectedCurrencySign = _getAllCurrenciesSign()[
          _getAllCurrencies().indexOf(selectedCurrency)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(searchBarTheme: AppTheme.searchBarTheme),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            textStyle: WidgetStatePropertyAll(
              Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            controller: controller,
            onTap: () {
              controller.openView();
            },
            onChanged: (query) {
              controller.openView();
            },
            leading: Text(
              selectedCurrencySign,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            hintText: selectedCurrency,
          );
        },
        suggestionsBuilder: (
          BuildContext context,
          SearchController controller,
        ) {
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
