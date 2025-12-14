import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/hive_service.dart';
import '../services/zlibrary_api.dart';
import 'zlibrary_provider.dart';

final domainListProvider = Provider<Map<String, String>>((ref) {
  return {
    'Line 1 (CN)': 'zkoo.site',
    'Line 2 (CN)': 'zlibrary-iran.ir',
    'Line 3 (CN)': 'freezlib.me',
    'Line 4 (CN)': 'fuckfbi.ru',
    'Line 5 (CN)': 'pkuedu.online',
    'Global': 'z-library.sk',
  };
});

final domainProvider = StateNotifierProvider<DomainNotifier, String>((ref) {
  final api = ref.watch(zlibraryApiProvider);
  return DomainNotifier(api);
});

class DomainNotifier extends StateNotifier<String> {
  final ZLibraryApi _api;

  DomainNotifier(this._api)
      : super(HiveService.settingsBox.get('domain', defaultValue: 'pkuedu.online')) {
    // Ensure API is in sync with initial state
    _api.setDomain(state);
  }

  void setDomain(String domain) {
    state = domain;
    HiveService.settingsBox.put('domain', domain);
    _api.setDomain(domain);
  }
  
  void setCustomDomain(String domain) {
    // Remove protocol if present
    String cleanDomain = domain.replaceAll(RegExp(r'^https?://'), '');
    if (cleanDomain.endsWith('/')) {
      cleanDomain = cleanDomain.substring(0, cleanDomain.length - 1);
    }
    setDomain(cleanDomain);
  }
}
