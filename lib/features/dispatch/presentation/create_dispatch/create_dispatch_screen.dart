import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopit_ui/loopit_ui.dart';

import '../widgets/priority_selector.dart';

// Mock campus data
class _MockCampus {
  final String id;
  final String name;
  const _MockCampus(this.id, this.name);
}

const _mockCampuses = [
  _MockCampus('campus-1', 'Main Campus'),
  _MockCampus('campus-2', 'North Campus'),
  _MockCampus('campus-3', 'South Campus'),
  _MockCampus('campus-4', 'East Campus'),
];

class CreateDispatchScreen extends ConsumerStatefulWidget {
  const CreateDispatchScreen({super.key});

  @override
  ConsumerState<CreateDispatchScreen> createState() => _CreateDispatchScreenState();
}

class _CreateDispatchScreenState extends ConsumerState<CreateDispatchScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _receiverNameController = TextEditingController();
  final _receiverPhoneController = TextEditingController();
  final _receiverEmailController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedPriority = 'Medium';
  String? _selectedItemType;
  _MockCampus? _selectedSenderCampus;
  _MockCampus? _selectedDestination;
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    _receiverEmailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateDispatch() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a dispatch title')),
      );
      return;
    }
    if (_selectedSenderCampus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a sender campus')),
      );
      return;
    }
    if (_selectedDestination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a destination campus')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      // Mock submission delay
      await Future.delayed(const Duration(seconds: 1));
      messenger.showSnackBar(
        const SnackBar(content: Text('Dispatch created successfully!')),
      );
      navigator.pop();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Error creating dispatch: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LoopitColors.grey50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: LoopitColors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: LoopitColors.black,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          'Create Dispatch',
          style: TextStyle(
            color: LoopitColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card 1: Dispatch Details
            _buildSectionCard(
              children: [
                _buildLabel('Dispatch Title'),
                _buildTextField(
                  controller: _titleController,
                  hint: 'Enter dispatch title',
                ),
                const SizedBox(height: 20),
                _buildLabel('Description'),
                _buildTextArea(
                  controller: _descriptionController,
                  hint: 'Enter description of the items, purpose, and\nany important details...',
                  maxLength: 300,
                ),
                const SizedBox(height: 20),
                _buildLabel('Item Type'),
                _buildDropdownField(
                  value: _selectedItemType,
                  hint: 'Select item type',
                  icon: Icons.inventory_2_outlined,
                  items: const ['Document', 'Package', 'Equipment', 'Other'],
                  onChanged: (val) => setState(() => _selectedItemType = val),
                ),
                const SizedBox(height: 20),
                _buildLabel('Priority'),
                PrioritySelector(
                  selectedPriority: _selectedPriority,
                  onPriorityChanged: (val) => setState(() => _selectedPriority = val),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Card 2: Receiver Details
            _buildSectionCard(
              title: 'Receiver Details',
              children: [
                _buildTextFieldWithPrefix(
                  controller: _receiverNameController,
                  hint: 'Receiver name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                _buildTextFieldWithPrefix(
                  controller: _receiverPhoneController,
                  hint: 'Phone number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _buildTextFieldWithPrefix(
                  controller: _receiverEmailController,
                  hint: 'Email address (Optional)',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Card 3: Route Details
            _buildSectionCard(
              title: 'Route Details',
              children: [
                _buildLabel('Sender Campus'),
                _buildCampusDropdownField(
                  value: _selectedSenderCampus,
                  hint: 'Sender Campus',
                  icon: Icons.unarchive_outlined,
                  items: _mockCampuses,
                  onChanged: (val) => setState(() => _selectedSenderCampus = val),
                ),
                const SizedBox(height: 16),
                _buildLabel('Destination Campus'),
                _buildCampusDropdownField(
                  value: _selectedDestination,
                  hint: 'Destination Campus',
                  icon: Icons.location_on_outlined,
                  items: _mockCampuses,
                  onChanged: (val) => setState(() => _selectedDestination = val),
                ),
                const SizedBox(height: 16),
                _buildLabel('Expected Delivery Date'),
                _buildReadOnlyFieldWithIcons(
                  hint: _selectedDate == null
                      ? 'Expected delivery date'
                      : "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}",
                  prefixIcon: Icons.calendar_today_outlined,
                  suffixIcon: Icons.calendar_today_outlined,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Card 4: Additional Notes
            _buildSectionCard(
              title: 'Additional Notes',
              children: [
                _buildTextArea(
                  controller: _notesController,
                  hint: 'Any additional remarks or special instructions...',
                  maxLength: 300,
                ),
              ],
            ),
            const SizedBox(height: 32),

            PremiumButton(
              text: _isSubmitting ? 'Creating...' : 'Create Dispatch',
              onPressed: _isSubmitting ? () {} : () => _handleCreateDispatch(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({String? title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: LoopitColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: LoopitColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: LoopitColors.black,
              ),
            ),
            const SizedBox(height: 16),
          ],
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: LoopitColors.black,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: LoopitColors.grey100),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: LoopitColors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: LoopitColors.grey300),
        ),
      ),
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String hint,
    required int maxLength,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: LoopitColors.grey100),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: controller,
            maxLines: 4,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: LoopitColors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(color: LoopitColors.grey300, height: 1.4),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '0/$maxLength',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: LoopitColors.grey300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithPrefix({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: LoopitColors.grey100),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: LoopitColors.black, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: LoopitColors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: LoopitColors.grey300),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: LoopitColors.grey100),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: LoopitColors.black, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text(
                  hint,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: LoopitColors.grey300,
                  ),
                ),
                icon: const Icon(Icons.keyboard_arrow_down, color: LoopitColors.black, size: 20),
                isExpanded: true,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: LoopitColors.black,
                ),
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampusDropdownField({
    required _MockCampus? value,
    required String hint,
    required IconData icon,
    required List<_MockCampus> items,
    required ValueChanged<_MockCampus?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: LoopitColors.grey100),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: LoopitColors.black, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<_MockCampus>(
                value: value,
                hint: Text(
                  hint,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: LoopitColors.grey300,
                  ),
                ),
                icon: const Icon(Icons.keyboard_arrow_down, color: LoopitColors.black, size: 20),
                isExpanded: true,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: LoopitColors.black,
                ),
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item.name),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyFieldWithIcons({
    required String hint,
    required IconData prefixIcon,
    required IconData suffixIcon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: LoopitColors.grey100),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(prefixIcon, color: LoopitColors.black, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hint,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: LoopitColors.grey300,
                ),
              ),
            ),
            Icon(suffixIcon, color: LoopitColors.black, size: 20),
          ],
        ),
      ),
    );
  }
}
