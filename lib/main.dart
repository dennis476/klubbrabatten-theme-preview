// Standalone Flutter Web preview of the Klubbrabatten in-app föreningstema.
// Embedded by the admin (Lovable) via an <iframe>; the accent colour + logo +
// name come from the URL query string:
//   ?primary=%23F2C200&logo=<logo-url>&name=Vaksala%20SK&city=Solna
// Mirrors the real themed home (home_page.dart / home_header.dart /
// category_rail.dart / section_header.dart / the Stötta card) — same dark base
// + token logic — so it is pixel-faithful.
import 'package:flutter/material.dart';

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
        // Club crest as a faint background watermark (matches home_page.dart).
        image: (logoUrl != null && logoUrl!.isNotEmpty)
            ? DecorationImage(
                image: NetworkImage(logoUrl!),
                alignment: const Alignment(1.15, -0.82),
                scale: 1.7,
                fit: BoxFit.none,
                opacity: 0.16,
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
            _stottaCard(onPrimary),
            const SizedBox(height: 20),
            _sectionHeader('Nyheter'),
            const SizedBox(height: 8),
            _newsCard(),
            const SizedBox(height: 14),
            _sectionHeader('Utvalda erbjudanden'),
            const SizedBox(height: 8),
            _offerRow(),
            const SizedBox(height: 24),
          ]),
        ),
        _navBar(onPrimary),
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
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: _orange, borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: const Text('K',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18)),
          ),
          const SizedBox(width: 8),
          const Text('KLUBB',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  letterSpacing: 0.3)),
          const Text('RABATTEN',
              style: TextStyle(
                  color: _orange,
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  letterSpacing: 0.3)),
          const Spacer(),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
                color: Color(0xFF24262C), shape: BoxShape.circle),
            child: const Icon(Icons.notifications_none_rounded,
                color: Colors.white, size: 22),
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
    const labels = ['Alla', 'Livsmedel', 'Restaurang', 'Sport & Fritid', 'Mode', 'Hem'];
    const icons = [
      Icons.grid_view_rounded,
      Icons.shopping_basket_outlined,
      Icons.restaurant,
      Icons.sports_soccer,
      Icons.checkroom,
      Icons.chair_outlined
    ];
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final selected = i == 0;
          return SizedBox(
            width: 60,
            child: Column(children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF1F6),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: selected ? _orange : Colors.transparent, width: 2),
                ),
                child: Icon(icons[i], color: const Color(0xFF14294A), size: 26),
              ),
              const SizedBox(height: 7),
              Text(labels[i],
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

  Widget _offerRow() => SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) => Container(
            width: 104,
            decoration: BoxDecoration(
                color: _surface, borderRadius: BorderRadius.circular(14)),
            child:
                const Center(child: Icon(Icons.image, color: Color(0xFF3A3C44))),
          ),
        ),
      );

  Widget _navBar(Color onPrimary) {
    const items = [
      ['Hem', Icons.home_rounded],
      ['Favoriter', Icons.favorite_border],
      ['Karta', Icons.map_outlined],
      ['Community', Icons.groups_outlined],
      ['Profil', Icons.person_outline],
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 18),
      decoration: const BoxDecoration(color: Color(0xFF16171B)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < items.length; i++)
            Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(items[i][1] as IconData,
                  color: i == 0 ? primary : const Color(0xFFA3ABB8), size: 24),
              const SizedBox(height: 4),
              Text(items[i][0] as String,
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
