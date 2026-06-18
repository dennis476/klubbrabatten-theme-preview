// Standalone Flutter Web preview of the Klubbrabatten in-app föreningstema.
// Embedded by the admin (Lovable) via an <iframe>; the accent colour + logo +
// name come from the URL query string:
//   ?primary=%23F2C200&logo=<logo-url>&name=Vaksala%20SK&city=Solna
// Faithful replica of the real Home v2 (home_page_content order: chip sections
// → Stötta-kort → Ludde-kort → Nyheter), using the SAME assets (KLUBBRABATTEN
// logo, 3D-brevlåda, 3D category icons, nav SVGs) + the same dark theme tokens.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const ClubThemePreviewApp());

// ── Fixed dark base tokens (must match lib/globals/club_theme.dart) ──────────
const Color _bgTop = Color(0xFF15161A);
const Color _bgBottom = Color(0xFF0D0E11);
const Color _surface = Color(0xFF1C1D21);
const Color _surfaceText = Color(0xFFFFFFFF);
const Color _surfaceSubtext = Color(0xFF9EA8B7);
const Color _orange = Color(0xFFF27B36);
const String _font = 'DM Sans';

Color _parseHex(String? hex) {
  if (hex == null) return const Color(0xFF2D7BE0);
  final s = hex.replaceFirst('#', '').trim();
  if (s.length != 6) return const Color(0xFF2D7BE0);
  final v = int.tryParse(s, radix: 16);
  return v == null ? const Color(0xFF2D7BE0) : Color(0xFF000000 | v);
}

Color _onColor(Color primary) =>
    primary.computeLuminance() > 0.5 ? const Color(0xFF1A1A1E) : Colors.white;

class ClubThemePreviewApp extends StatelessWidget {
  const ClubThemePreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    final q = Uri.base.queryParameters;
    final primary = _parseHex(q['primary']);
    final logo = q['logo'];
    final name = (q['name'] == null || q['name']!.trim().isEmpty)
        ? 'Din förening'
        : q['name']!.trim();
    final city = q['city'];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: _font),
      home: Scaffold(
        backgroundColor: const Color(0xFFE9ECF1),
        body: Center(
          child: _PhoneFrame(
            child: _ThemedHome(
                primary: primary, logoUrl: logo, name: name, city: city),
          ),
        ),
      ),
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      height: 844,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(44),
        border: Border.all(color: const Color(0xFF111317), width: 10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 40,
              offset: const Offset(0, 20)),
        ],
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(34), child: child),
    );
  }
}

class _ThemedHome extends StatelessWidget {
  const _ThemedHome(
      {required this.primary,
      required this.logoUrl,
      required this.name,
      required this.city});
  final Color primary;
  final String? logoUrl;
  final String name;
  final String? city;

  @override
  Widget build(BuildContext context) {
    final onPrimary = _onColor(primary);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.alphaBlend(primary.withValues(alpha: 0.22), _bgTop),
            _bgTop,
            _bgBottom,
          ],
          stops: const [0.0, 0.26, 1.0],
        ),
        // Club crest as a large, faint, full-resolution background watermark
        // (upper, slightly right-of-centre). Matches home_page.dart.
        image: (logoUrl != null && logoUrl!.isNotEmpty)
            ? DecorationImage(
                image: NetworkImage(logoUrl!),
                alignment: const Alignment(0.55, -0.62),
                scale: 1.55,
                fit: BoxFit.none,
                opacity: 0.15,
              )
            : null,
      ),
      child: Column(children: [
        Expanded(
          child: ListView(padding: EdgeInsets.zero, children: [
            const SizedBox(height: 14),
            _statusBar(),
            const SizedBox(height: 10),
            _header(),
            const SizedBox(height: 8),
            _location(),
            const SizedBox(height: 12),
            _search(),
            const SizedBox(height: 16),
            _categoryRail(),
            const SizedBox(height: 18),
            _chipSection(),
            const SizedBox(height: 18),
            _stottaCard(onPrimary),
            const SizedBox(height: 14),
            _luddeCard(),
            const SizedBox(height: 20),
            _sectionHeader('Nyheter'),
            const SizedBox(height: 8),
            _newsCard(),
            const SizedBox(height: 24),
          ]),
        ),
        _navBar(),
      ]),
    );
  }

  Widget _statusBar() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 22),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('09:41',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
          Row(children: [
            Icon(Icons.signal_cellular_alt, color: Colors.white, size: 16),
            SizedBox(width: 5),
            Icon(Icons.wifi, color: Colors.white, size: 16),
            SizedBox(width: 5),
            Icon(Icons.battery_full, color: Colors.white, size: 18),
          ]),
        ]),
      );

  Widget _header() => Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 20, 0),
        child: Row(children: [
          // Real KLUBBRABATTEN logo (white-on-dark variant).
          Image.asset('assets/brand/header_logo_dark.webp',
              height: 30, fit: BoxFit.contain, alignment: Alignment.centerLeft),
          const Spacer(),
          // Real 3D mailbox notification button (glass circle).
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF24262C),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            padding: const EdgeInsets.all(7),
            child: Image.asset('assets/ic_notification_3d.png',
                fit: BoxFit.contain),
          ),
        ]),
      );

  Widget _location() => const Padding(
        padding: EdgeInsets.fromLTRB(22, 0, 20, 0),
        child: Row(children: [
          Icon(Icons.location_on, color: Color(0xFFC8CED8), size: 18),
          SizedBox(width: 6),
          Text('Solna • Inom 50 km',
              style: TextStyle(
                  color: Color(0xFFC8CED8),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500)),
          Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFFC8CED8), size: 18),
        ]),
      );

  Widget _search() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: const Row(children: [
            Icon(Icons.search, color: Color(0xFF8A94A6), size: 22),
            SizedBox(width: 10),
            Text('Sök erbjudanden, butiker, kategorier…',
                style: TextStyle(color: Color(0xFF8A94A6), fontSize: 14)),
          ]),
        ),
      );

  Widget _categoryRail() {
    // Real categories + order (DB sort_order) with the actual 3D Wolt icons.
    const cats = <List<String>>[
      ['Alla', 'alla'],
      ['Livsmedel', 'livsmedel'],
      ['Restaurang & Café', 'restaurang-cafe'],
      ['Sport & Fritid', 'sport-fritid'],
      ['Fordon', 'fordon'],
      ['Mode', 'mode'],
      ['Hem & Elektronik', 'hem-elektronik'],
      ['Hälsa & Skönhet', 'halsa-skonhet'],
      ['Aktiviteter', 'aktiviteter'],
      ['Onlinerabatter', 'onlinerabatter'],
    ];
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final selected = i == 0;
          return SizedBox(
            width: 62,
            child: Column(children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF1F6),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: selected ? _orange : Colors.transparent, width: 2),
                ),
                child: Image.asset('assets/cat/${cats[i][1]}.webp',
                    width: 40, height: 40),
              ),
              const SizedBox(height: 7),
              Text(cats[i][0],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color:
                          selected ? _orange : const Color(0xFFC8CED8))),
            ]),
          );
        },
      ),
    );
  }

  // Home v2 chip section (HomeOffersChipsSection): chip tabs + an offer carousel.
  Widget _chipSection() {
    const chips = ['Flest inlösen', 'Trendar just nu', 'Nyheter'];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: chips.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final sel = i == 0;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: sel ? primary.withValues(alpha: 0.18) : _surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: sel
                        ? primary.withValues(alpha: 0.6)
                        : const Color(0xFF2E3036)),
              ),
              child: Text(chips[i],
                  style: TextStyle(
                      color: sel ? primary : _surfaceSubtext,
                      fontSize: 13,
                      fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
            );
          },
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 150,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) => _offerCard(['25%', '15%', '30%', '20%'][i],
              ['Stadium', 'ICA Maxi', 'Pizza Hut', 'Apotek'][i]),
        ),
      ),
    ]);
  }

  Widget _offerCard(String pct, String name) => Container(
        width: 130,
        decoration: BoxDecoration(
            color: _surface, borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            Container(
              height: 90,
              decoration: const BoxDecoration(
                  color: Color(0xFF2A2C33),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16))),
              child:
                  const Center(child: Icon(Icons.image, color: Color(0xFF3A3C44))),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: primary, borderRadius: BorderRadius.circular(8)),
                child: Text(pct,
                    style: TextStyle(
                        color: _onColor(primary),
                        fontWeight: FontWeight.w800,
                        fontSize: 12)),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name,
                  style: const TextStyle(
                      color: _surfaceText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              const Text('1,5 km',
                  style: TextStyle(color: _surfaceSubtext, fontSize: 11.5)),
            ]),
          ),
        ]),
      );

  Widget _stottaCard(Color onPrimary) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: _surface, borderRadius: BorderRadius.circular(20)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14)),
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                child: (logoUrl != null && logoUrl!.isNotEmpty)
                    ? Image.network(logoUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.shield_outlined, color: Color(0xFF8A94A6)))
                    : const Icon(Icons.shield_outlined,
                        color: Color(0xFF8A94A6)),
              ),
              const SizedBox(width: 13),
              Expanded(
                child:
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Stötta $name',
                      style: const TextStyle(
                          color: _surfaceText,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(city == null || city!.isEmpty ? 'Allsvenskan' : city!,
                      style:
                          const TextStyle(color: _surfaceSubtext, fontSize: 13)),
                ]),
              ),
              const Icon(Icons.chevron_right, color: _surfaceSubtext),
            ]),
            const SizedBox(height: 16),
            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('62% av målet sålt',
                  style: TextStyle(
                      color: _surfaceText,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600)),
              Text('Sålda 62/100',
                  style: TextStyle(color: _surfaceSubtext, fontSize: 13)),
            ]),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Stack(children: [
                Container(height: 9, color: const Color(0xFF33353C)),
                FractionallySizedBox(
                    widthFactor: 0.62,
                    child: Container(height: 9, color: primary)),
              ]),
            ),
            const SizedBox(height: 14),
            Row(children: [
              const Expanded(
                child: Text('38 köp kvar till milstolpe',
                    style: TextStyle(color: _surfaceSubtext, fontSize: 12.5)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                decoration: BoxDecoration(
                    color: primary, borderRadius: BorderRadius.circular(24)),
                child: Text('Köp nu',
                    style: TextStyle(
                        color: onPrimary, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF80868F))),
                child: const Text('Dela',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ]),
          ]),
        ),
      );

  Widget _luddeCard() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: const Color(0xFF1E2024),
              borderRadius: BorderRadius.circular(18)),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.18),
                  shape: BoxShape.circle),
              child: Icon(Icons.smart_toy_outlined, color: primary, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Chatta med Ludde',
                        style: TextStyle(
                            color: _surfaceText,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5)),
                    SizedBox(height: 2),
                    Text('Din AI-assistent som hjälper dig spara mer.',
                        style:
                            TextStyle(color: _surfaceSubtext, fontSize: 12)),
                  ]),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primary)),
              child: Text('Chatta',
                  style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5)),
            ),
          ]),
        ),
      );

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const Text('Visa alla',
              style: TextStyle(color: Color(0xFF9EA8B7), fontSize: 13)),
        ]),
      );

  Widget _newsCard() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 96,
          decoration: BoxDecoration(
              color: _surface, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                  color: Color(0xFF2A2C33),
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(16))),
              child: const Icon(Icons.local_pizza, color: Color(0xFF6B7280)),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Ny aktör: Pizza Hut Uppsala',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                      SizedBox(height: 4),
                      Text('En ny aktör har lagts till i Uppsala.',
                          style: TextStyle(
                              color: Color(0xFF9EA8B7), fontSize: 12)),
                    ]),
              ),
            ),
          ]),
        ),
      );

  Widget _navBar() {
    const items = [
      ['Hem', 'assets/nav/nav_tab_home.svg'],
      ['Favoriter', 'assets/nav/nav_tab_favorite.svg'],
      ['Karta', 'assets/nav/nav_tab_map.svg'],
      ['Community', 'assets/nav/nav_tab_community.svg'],
      ['Profil', 'assets/nav/nav_tab_profile.svg'],
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 18),
      decoration: const BoxDecoration(color: Color(0xFF16171B)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < items.length; i++)
            Column(mainAxisSize: MainAxisSize.min, children: [
              SvgPicture.asset(items[i][1],
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                      i == 0 ? primary : const Color(0xFFA3ABB8),
                      BlendMode.srcIn)),
              const SizedBox(height: 4),
              Text(items[i][0],
                  style: TextStyle(
                      color: i == 0 ? primary : const Color(0xFFA3ABB8),
                      fontSize: 11,
                      fontWeight:
                          i == 0 ? FontWeight.w700 : FontWeight.w500)),
            ]),
        ],
      ),
    );
  }
}
